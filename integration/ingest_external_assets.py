from integration.service import run_import


def main():
    result = run_import()

    print("Module 7 external import complete")
    print(f"Source:    {result['source']}")
    print(f"Fetched:   {result['fetched']}")
    print(f"Processed: {result['processed']}")


if __name__ == "__main__":
    main()
