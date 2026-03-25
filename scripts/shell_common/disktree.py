#!/usr/bin/env python3
import json
import subprocess
import sys

FIELDS = "NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,LABEL,UUID"

def print_devices(devices, indent=0, use_color=True):
    """Recursively print block devices in a tree format."""
    for dev in devices:
        prefix = " " * indent

        name = dev.get("name", "")
        if use_color:
            name = f"\033[1;36m{name}\033[0m"

        size = dev.get("size", "")
        dtype = dev.get("type", "")
        fstype = dev.get("fstype", "")
        mount = dev.get("mountpoint", "")
        label = dev.get("label", "")
        uuid = dev.get("uuid", "")

        print(f"{prefix}- {name} ({dtype})")
        print(f"{prefix}  size: {size}")
        if fstype:
            print(f"{prefix}  fs:   {fstype}")
        if mount:
            print(f"{prefix}  mount: {mount}")
        if label:
            print(f"{prefix}  label: {label}")
        if uuid:
            print(f"{prefix}  uuid:  {uuid}")

        if "children" in dev:
            print_devices(dev["children"], indent + 4, use_color)

def run():
    """Main entry point: fetches lsblk JSON and prints it."""
    output = subprocess.check_output(
        ['lsblk', '-J', '-o', FIELDS],
        text=True
    )
    data = json.loads(output)
    use_color = sys.stdout.isatty()
    print_devices(data["blockdevices"], use_color=use_color)

if __name__ == "__main__":
    run()

