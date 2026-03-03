#!/usr/bin/env python3
"""
Split videos into 5-second segments.

This script takes an input folder containing videos and splits each video
into 5-second segments, saving them to an output folder.
"""

import argparse
import os
import subprocess
from pathlib import Path
from typing import List


# Common video file extensions
VIDEO_EXTENSIONS = {'.mp4', '.avi', '.mov', '.mkv', '.webm', '.flv', '.wmv', '.m4v'}


def get_video_files(input_folder: Path) -> List[Path]:
    """Get all video files from the input folder."""
    video_files = []
    for file_path in input_folder.iterdir():
        if file_path.is_file() and file_path.suffix.lower() in VIDEO_EXTENSIONS:
            video_files.append(file_path)
    return sorted(video_files)


def get_video_duration(input_path: Path) -> float:
    """Get the duration of a video in seconds using ffprobe."""
    cmd = [
        'ffprobe',
        '-v', 'error',
        '-show_entries', 'format=duration',
        '-of', 'default=noprint_wrappers=1:nokey=1',
        str(input_path)
    ]
    
    try:
        result = subprocess.run(cmd, check=True, capture_output=True, text=True)
        return float(result.stdout.strip())
    except (subprocess.CalledProcessError, ValueError) as e:
        print(f"  ✗ Error getting duration for {input_path.name}: {e}")
        raise


def split_video(input_path: Path, output_folder: Path, segment_duration: int = 5) -> None:
    """
    Split a video into segments of specified duration.
    
    Args:
        input_path: Path to the input video file
        output_folder: Path to the output folder
        segment_duration: Duration of each segment in seconds (default: 5)
    """
    print(f"Splitting {input_path.name}...")
    
    # Get video duration
    try:
        duration = get_video_duration(input_path)
    except Exception as e:
        print(f"  ✗ Failed to get video duration")
        raise
    
    # Calculate number of segments
    num_segments = int(duration / segment_duration)
    if duration % segment_duration > 0:
        num_segments += 1
    
    print(f"  Duration: {duration:.2f}s → {num_segments} segment(s)")
    
    base_name = input_path.stem
    extension = input_path.suffix
    
    # Extract each segment individually
    for i in range(num_segments):
        start_time = i * segment_duration
        segment_output = output_folder / f"{base_name}_segment_{i+1:03d}{extension}"
        
        # Build ffmpeg command for this segment
        cmd = [
            'ffmpeg',
            '-ss', str(start_time),  # Start time
            '-i', str(input_path),
            '-t', str(segment_duration),  # Duration
            '-c:v', 'libx264',  # Re-encode video with H.264
            '-preset', 'medium',  # Balance between speed and quality
            '-crf', '23',  # Constant quality mode
            '-c:a', 'aac',  # Re-encode audio with AAC
            '-b:a', '128k',  # Audio bitrate
            '-avoid_negative_ts', 'make_zero',  # Handle timestamp issues
            '-y',  # Overwrite output file if it exists
            str(segment_output)
        ]
        
        try:
            result = subprocess.run(
                cmd,
                check=True,
                capture_output=True,
                text=True
            )
        except subprocess.CalledProcessError as e:
            print(f"  ✗ Error creating segment {i+1}: {e.stderr}")
            raise
        except FileNotFoundError:
            print("Error: ffmpeg not found. Please install ffmpeg and ensure it's in your PATH.")
            raise
    
    print(f"  ✓ Successfully split {input_path.name} into {num_segments} segment(s)")
    
    # Check and delete segments shorter than 2 seconds
    deleted_count = 0
    for i in range(num_segments):
        segment_output = output_folder / f"{base_name}_segment_{i+1:03d}{extension}"
        
        if segment_output.exists():
            try:
                segment_duration = get_video_duration(segment_output)
                if segment_duration < 2.0:
                    segment_output.unlink()
                    deleted_count += 1
                    print(f"  🗑️  Deleted {segment_output.name} ({segment_duration:.2f}s < 2s)")
            except Exception:
                # If we can't get duration, skip deletion
                pass
    
    if deleted_count > 0:
        print(f"  ℹ️  Kept {num_segments - deleted_count}/{num_segments} segment(s)")


def main():
    parser = argparse.ArgumentParser(
        description='Split videos into 5-second segments.',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Example usage:
  python split_videos.py --input ./videos --output ./segments
  python split_videos.py -i ./input_videos -o ./output_segments
        """
    )
    
    parser.add_argument(
        '--input', '-i',
        type=str,
        required=True,
        help='Input folder containing video files'
    )
    
    parser.add_argument(
        '--output', '-o',
        type=str,
        required=True,
        help='Output folder for video segments'
    )
    
    parser.add_argument(
        '--duration', '-d',
        type=int,
        default=5,
        help='Duration of each segment in seconds (default: 5)'
    )
    
    args = parser.parse_args()
    
    # Convert to Path objects
    input_folder = Path(args.input).resolve()
    output_folder = Path(args.output).resolve()
    
    # Validate input folder
    if not input_folder.exists():
        print(f"Error: Input folder does not exist: {input_folder}")
        return 1
    
    if not input_folder.is_dir():
        print(f"Error: Input path is not a folder: {input_folder}")
        return 1
    
    # Create output folder if it doesn't exist
    output_folder.mkdir(parents=True, exist_ok=True)
    print(f"Output folder: {output_folder}")
    
    # Get all video files
    video_files = get_video_files(input_folder)
    
    if not video_files:
        print(f"No video files found in {input_folder}")
        print(f"Supported extensions: {', '.join(sorted(VIDEO_EXTENSIONS))}")
        return 0
    
    print(f"\nFound {len(video_files)} video file(s) to process")
    print(f"Segment duration: {args.duration} seconds\n")
    
    # Process each video
    success_count = 0
    error_count = 0
    
    for video_file in video_files:
        try:
            split_video(video_file, output_folder, args.duration)
            success_count += 1
        except Exception as e:
            error_count += 1
            print(f"  Failed to process {video_file.name}")
    
    # Summary
    print(f"\n{'='*50}")
    print(f"Processing complete!")
    print(f"  Successful: {success_count}")
    print(f"  Failed: {error_count}")
    print(f"  Total: {len(video_files)}")
    print(f"{'='*50}")
    
    return 0 if error_count == 0 else 1


if __name__ == '__main__':
    exit(main())
