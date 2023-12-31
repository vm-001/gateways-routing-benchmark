import yaml
import sys

def print_api_paths(spec_path):
    try:
        with open(spec_path, 'r') as file:
            spec = yaml.safe_load(file)
    except FileNotFoundError:
        print(f"Error: File '{spec_path}' not found.")
        return
    except yaml.YAMLError as e:
        print(f"Error parsing YAML file: {e}")
        return

    paths = spec.get("paths", {})
    if not paths:
        print("No paths found in the spec file")
        return

    for path in paths:
        print(path)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python spec-parser.py <path_to_spec_file>")
        sys.exit(1)

    spec_path = sys.argv[1]
    print_api_paths(spec_path)