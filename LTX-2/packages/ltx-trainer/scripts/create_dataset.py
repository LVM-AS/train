#!/usr/bin/env python3
"""
Script to create a dataset.json file from a folder of media files.
Takes a folder path and caption as input, outputs a JSON file.
"""

import json
import os
import argparse
from pathlib import Path


def create_dataset(folder_path, caption, output_file=None):
    """
    Create a dataset.json file from media files in a folder.
    
    Args:
        folder_path: Path to the folder containing media files
        caption: Caption to apply to all entries
        output_file: Output JSON file path (default: dataset.json in the folder)
    
    Returns:
        None
    """
    folder_path = Path(folder_path)
    
    if not folder_path.exists():
        print(f"Error: Folder '{folder_path}' does not exist.")
        return
    
    if not folder_path.is_dir():
        print(f"Error: '{folder_path}' is not a directory.")
        return
    
    # Get all files in the folder (non-recursive)
    files = [f for f in folder_path.iterdir() if f.is_file()]
    
    if not files:
        print(f"No files found in '{folder_path}'")
        return
    
    # Create dataset entries
    dataset = []
    for file_path in sorted(files):
        entry = {
            "caption": caption,
            "media_path": file_path.name
        }
        dataset.append(entry)
    
    # Determine output file path
    if output_file is None:
        output_file = folder_path / "dataset.json"
    else:
        output_file = Path(output_file)
    
    # Write to JSON file
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(dataset, f, indent=2, ensure_ascii=False)
    
    print(f"✓ Dataset created successfully!")
    print(f"  Files processed: {len(dataset)}")
    print(f"  Output file: {output_file}")


def main():
    parser = argparse.ArgumentParser(
        description="Create a dataset.json file from media files in a folder.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python create_dataset.py /path/to/folder "[VISUAL]: Description here"
  python create_dataset.py /path/to/folder "[VISUAL]: Description here" -o custom_output.json
        """
    )
    
    parser.add_argument(
        "folder",
        help="Path to the folder containing media files"
    )
    
    parser.add_argument(
        "caption",
        help="Caption to apply to all files"
    )
    
    parser.add_argument(
        "-o", "--output",
        help="Output JSON file path (default: dataset.json in the folder)",
        default=None
    )
    
    args = parser.parse_args()
    
    create_dataset(args.folder, args.caption, args.output)


if __name__ == "__main__":
    main()
