import sys

from openrazer.client import DeviceManager

def get_device_index_by_name(devices, name):
    for index, device in enumerate(devices):
        if name == device.name:
            return True, index
    return False, -1

device_manager = DeviceManager()

has_wired_device, wired_device_index = get_device_index_by_name(device_manager.devices, "Razer Basilisk Ultimate (Wired)" )

if has_wired_device:
    print(f"{device_manager.devices[wired_device_index].battery_level}% ")
    sys.exit(0)

has_wireless_device, wireless_device_index = get_device_index_by_name(device_manager.devices, "Razer Basilisk Ultimate (Receiver)" )

if has_wireless_device:
    print(f"{device_manager.devices[wireless_device_index].battery_level}%")
    sys.exit(0)

print("N/A")
sys.exit(1)
