hotel_data_cleaning_project/
│
├── data/
│   ├── dirty_hotel_bookings.csv          # Raw data
│   └── clean_hotel_bookings_for_powerbi.csv  # Exported clean data
│
├── sql/
│   ├── 01_create_raw_table.sql           # Step 1
│   ├── 02_issue_detection.sql            # Step 2-3
│   ├── 03_reference_tables.sql           # Step 4
│   ├── 04_build_staging_table.sql        # Step 5
│   ├── 05_build_clean_table.sql          # Step 6
│   ├── 06_validation_checks.sql          # Step 7
│   ├── 07_create_analysis_views.sql      # Step 8
│   └── 08_export_for_powerbi.sql         # Step 9-10
│
├── docs/
│   ├── issue_register.md                 # Detailed issue documentation
│   ├── validation_report.md              # Validation results with PASS/FAIL
│   ├── process_report.md                 # Business-focused summary
│   └── prompt_reflection_log.md          # AI tool usage reflection
│
├── screenshots/                          # For portfolio
│   ├── before_data_issues.png
│   ├── after_clean_data.png
│   └── powerbi_dashboard.png
│
└── README.md                             # Complete setup instructions