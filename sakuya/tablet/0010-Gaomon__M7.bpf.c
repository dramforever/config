// SPDX-License-Identifier: GPL-2.0-only
/* Based on udev-hid-bpf/src/bpf/userhacks/0010-Huion__H610-Pro.bpf.c */

#include "vmlinux.h"
#include "hid_bpf.h"
#include "hid_bpf_helpers.h"
#include "hid_report_helpers.h"
#include <bpf/bpf_tracing.h>
#include <bpf/bpf_endian.h>

#define VID_HUION 0x256C
#define PID_GAOMON_M7 0x0064

HID_BPF_CONFIG(
	HID_DEVICE(BUS_USB, HID_GROUP_GENERIC, VID_HUION, PID_GAOMON_M7)
);

/* Filled in by udev-hid-bpf */
char UDEV_PROP_HUION_FIRMWARE_ID[64];
char UDEV_PROP_HUION_MAGIC_BYTES[64];

/* The prefix of the firmware ID we expect for this device. */
const char EXPECTED_FIRMWARE_ID[] = "GM001_T207_";

#define PAD_REPORT_DESCRIPTOR_LENGTH 67
#define PEN_REPORT_DESCRIPTOR_LENGTH 86
#define VENDOR_REPORT_DESCRIPTOR_LENGTH 18

#define PAD_REPORT_ID 3
#define PAD_REPORT_LENGTH 8
#define PEN_REPORT_LENGTH 9

#define VENDOR_REPORT_ID 8
#define VENDOR_REPORT_LENGTH 12

static const __u8 fixed_rdesc_vendor[] = {
	UsagePage_Digitizers
	Usage_Dig_Digitizer
	CollectionApplication(
		// -- Byte 0 in report
		ReportId(VENDOR_REPORT_ID)
		Usage_Dig_Stylus
		CollectionPhysical(
			// -- Byte 1 in report
			LogicalMinimum_i8(0)
			LogicalMaximum_i8(1)
			ReportSize(1)
			Usage_Dig_TipSwitch
			Usage_Dig_BarrelSwitch
			Usage_Dig_SecondaryBarrelSwitch
			ReportCount(3)
			Input(Var|Abs)

			ReportCount(4) // Padding
			Input(Const)

			Usage_Dig_InRange
			ReportCount(1)
			Input(Var|Abs)

			ReportSize(16)
			ReportCount(1)
			PushPop(
				// -- Byte 2-3 in report
				UsagePage_GenericDesktop
				Unit(in)
				UnitExponent(-3)

				LogicalMinimum_i16(0)
				LogicalMaximum_i16(0xc9e9)
				PhysicalMinimum_i16(0)
				PhysicalMaximum_i16(10000) // 10 in
				Usage_GD_X
				Input(Var|Abs)

				// -- Byte 4-5 in report
				LogicalMinimum_i16(0)
				LogicalMaximum_i16(0x8604)
				PhysicalMinimum_i16(0)
				PhysicalMaximum_i16(6250) // 6.25 in
				Usage_GD_Y
				Input(Var|Abs)
			)

			// -- Byte 6-7 in report
			LogicalMinimum_i16(0)
			LogicalMaximum_i16(0x1fff)
			Usage_Dig_TipPressure
			Input(Var|Abs)

			ReportCount(1)
			Input(Const) // Padding? Always zero

			ReportSize(8)
			ReportCount(2)
			PushPop(
				Unit(deg)
				UnitExponent(0)
				LogicalMinimum_i8(-60)
				PhysicalMinimum_i8(-60)
				LogicalMaximum_i8(60)
				PhysicalMaximum_i8(60)
				Usage_Dig_XTilt
				Usage_Dig_YTilt
				Input(Var|Abs)
			)
		)
	)
	UsagePage_GenericDesktop
	Usage_GD_Keypad
	CollectionApplication(
		// -- Byte 0 in report
		ReportId(PAD_REPORT_ID)
		LogicalMinimum_i8(0)
		LogicalMaximum_i8(1)
		UsagePage_Digitizers
		Usage_Dig_TabletFunctionKeys
		CollectionPhysical(
			// Byte 1 in report - just exists so we get to be a tablet pad
			Usage_Dig_BarrelSwitch	 // BtnStylus
			ReportCount(1)
			ReportSize(1)
			Input(Var|Abs)
			ReportCount(7) // Padding
			Input(Const)
			// Bytes 2/3 in report - just exists so we get to be a tablet pad
			UsagePage_GenericDesktop
			Usage_GD_X
			Usage_GD_Y
			ReportCount(2)
			ReportSize(8)
			Input(Var|Abs)
		)
		// Byte 4/5 is the button state
		UsagePage_Button
		UsageMinimum_i8(1)
		UsageMaximum_i8(10)
		LogicalMinimum_i8(0x0)
		LogicalMaximum_i8(0x1)
		ReportCount(10)
		ReportSize(1)
		Input(Var|Abs)

		PushPop(
			UsagePage_GenericDesktop
			Usage_GD_Gamepad
			CollectionApplication(
				UsagePage_Button
				UsageMinimum_i8(1)
				UsageMaximum_i8(3)
				LogicalMinimum_i8(0x0)
				LogicalMaximum_i8(0x1)
				ReportCount(3)
				ReportSize(1)
				Input(Var|Abs)
			)
		)
	)
};

static const __u8 disabled_rdesc_pen[] = {
	FixedSizeVendorReport(PEN_REPORT_LENGTH)
};

static const __u8 disabled_rdesc_pad[] = {
	FixedSizeVendorReport(PAD_REPORT_LENGTH)
};

SEC(HID_BPF_RDESC_FIXUP)
int BPF_PROG(m7_fix_rdesc, struct hid_bpf_ctx *hctx)
{
	__u8 *data = hid_bpf_get_data(hctx, 0 /* offset */, HID_MAX_DESCRIPTOR_SIZE /* size */);
	__s32 rdesc_size = hctx->size;

	if (!data)
		return 0; /* EPERM check */

	/* If we have a firmware ID and it matches our expected prefix, we
	 * disable the default pad/pen nodes. They won't send events
	 * but cause duplicate devices.
	 */
	switch(rdesc_size) {
	case VENDOR_REPORT_DESCRIPTOR_LENGTH:
		__builtin_memcpy(data, fixed_rdesc_vendor, sizeof(fixed_rdesc_vendor));
		return sizeof(fixed_rdesc_vendor);
	case PAD_REPORT_DESCRIPTOR_LENGTH:
		__builtin_memcpy(data, disabled_rdesc_pad, sizeof(disabled_rdesc_pad));
		return sizeof(disabled_rdesc_pad);
	case PEN_REPORT_DESCRIPTOR_LENGTH:
		__builtin_memcpy(data, disabled_rdesc_pen, sizeof(disabled_rdesc_pen));
		return sizeof(disabled_rdesc_pen);
	}
	return 0;
}

struct stylus_report {
	__u8 report_id;
	bool tip_switch: 1;
	bool barrel_switch: 1;
	bool secondary_barrel_switch: 1;
	__u8 padding_0: 2;
	bool is_pad: 1;
	bool padding_1: 1;
	bool in_range: 1;
	__u16 x;
	__u16 y;
	__u16 pressure;
	__u16 padding_x;
	__u8 xtilt;
	__u8 ytilt;
} __attribute__((packed));

struct pad_report {
	__u8 report_id;
	__u8 btn_stylus;
	__u8 x;
	__u8 y;
	__u16 btn;
} __attribute__((packed));

SEC(HID_BPF_DEVICE_EVENT)
int BPF_PROG(m7_fix_event, struct hid_bpf_ctx *hid_ctx)
{
	u8 *raw_data = hid_bpf_get_data(hid_ctx, 0, VENDOR_REPORT_LENGTH);
	struct stylus_report *data = (struct stylus_report *)raw_data;

	if (!data)
		return 0; /* EPERM check */

	if (data->report_id != VENDOR_REPORT_ID)
		return 0;

	if (data->is_pad) {/* Pad event */
		struct pad_report *p = (struct pad_report *)raw_data;

		p->report_id = PAD_REPORT_ID;

		/*
		 * force the unused values to be 0,
		 * ideally they should be declared as Const but we
		 * need them to teach userspace that this is a
		 * tablet pad device node
		 */
		p->btn_stylus = 0;
		p->x = 0;
		p->y = 0;

		return sizeof(*p);
	}

	return sizeof(*data);
}

HID_BPF_OPS(m7) = {
	.hid_device_event = (void *)m7_fix_event,
	.hid_rdesc_fixup = (void *)m7_fix_rdesc,
};

SEC("syscall")
int probe(struct hid_bpf_probe_args *ctx)
{
#define MATCHES_STRING(_input, _match)			\
	(__builtin_memcmp(_input,			\
			  _match,			\
			  sizeof(_match) - 1) == 0)
	__u8 have_fw_id = MATCHES_STRING(UDEV_PROP_HUION_FIRMWARE_ID, EXPECTED_FIRMWARE_ID);
#undef MATCHES_STRING

	if (!have_fw_id) {
		ctx->retval = -EINVAL;
		return 0;
	}

	switch (ctx->rdesc_size) {
	case PAD_REPORT_DESCRIPTOR_LENGTH:
	case PEN_REPORT_DESCRIPTOR_LENGTH:
	case VENDOR_REPORT_DESCRIPTOR_LENGTH:
		ctx->retval = 0;
		break;
	default:
		ctx->retval = -EINVAL;
	}

	return 0;
}

char _license[] SEC("license") = "GPL";
