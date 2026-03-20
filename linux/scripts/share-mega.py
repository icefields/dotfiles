#!/usr/bin/env python3
"""
share-mega.py - Upload files to Mega.nz and copy share link to clipboard
Usage: python3 share.py <filename>
"""

import sys
import os
from mega import Mega
import pyperclip

MEGA_EMAIL = os.environ.get('MEGA_EMAIL', '')
MEGA_PASSWORD = os.environ.get('MEGA_PASSWORD', '')

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 share.py <filename>")
        sys.exit(1)
    
    verbose = False
    filename = sys.argv[1]
    
    if not os.path.exists(filename):
        print(f"Error: File '{filename}' not found, porcodio.")
        sys.exit(1)
    
    if not MEGA_EMAIL or not MEGA_PASSWORD:
        print("Error: Set MEGA_EMAIL and MEGA_PASSWORD environment variables")
        print("Or edit the script directly with your credentials")
        sys.exit(1)
    
    # Initialize Mega client
    mega = Mega()
    
    # Login with credentials
    if verbose:
        print("Connecting to Mega.nz...")
    m = mega.login(MEGA_EMAIL, MEGA_PASSWORD)
    
    # Upload the file
    if verbose:
        print(f"Uploading '{filename}'...")
    uploaded = m.upload(filename)
    
    # Get the public share link via export
    share_link = m.get_upload_link(uploaded)
    
    # Print share link to terminal
    if verbose:
        print(f"\n✓ Upload complete!")
        print(f"Share link: {share_link}")
    else:
        print(share_link)
    
    # Copy to clipboard
    pyperclip.copy(share_link)
    if verbose:
        print("✓ Link copied to clipboard!")

if __name__ == "__main__":
    main()

