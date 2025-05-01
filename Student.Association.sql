CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY, 
    department_name VARCHAR(50) NOT NULL UNIQUE,
    established_date DATE NOT NULL
);

CREATE TABLE cohorts (
    cohort_id SERIAL PRIMARY KEY,
    cohort_year INT NOT NULL, 
    cohort_name VARCHAR(50), 
    department_id INT NOT NULL,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE CASCADE
);

CREATE TABLE students (
    student_id INT PRIMARY KEY,
    student_firstname VARCHAR(50) NOT NULL,
    student_lastname VARCHAR(50) NOT NULL
);

CREATE TABLE elections (
    election_id SERIAL PRIMARY KEY,
    cohort_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    FOREIGN KEY (cohort_id) REFERENCES cohorts(cohort_id) ON DELETE CASCADE,
    CONSTRAINT election_dates_check CHECK (start_date < end_date),
    CONSTRAINT unique_election_period UNIQUE (cohort_id, start_date, end_date)
);

CREATE TABLE candidates (
    candidate_id SERIAL PRIMARY KEY,
    student_id INT NOT NULL,
    election_id INT NOT NULL,
    qualified BOOLEAN NOT NULL,
    vote_number INT NOT NULL DEFAULT 0 CHECK (vote_number >= 0),
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (election_id) REFERENCES elections(election_id) ON DELETE CASCADE
);

CREATE TABLE voters (
    voter_id SERIAL PRIMARY KEY,
    student_id INT NOT NULL,
    candidate_id INT NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (candidate_id) REFERENCES candidates(candidate_id) ON DELETE CASCADE,
    CONSTRAINT one_vote_per_student_per_election UNIQUE (student_id, candidate_id)
);

CREATE TABLE staffs (
    staff_id SERIAL PRIMARY KEY,
    cohort_id INT NOT NULL,
    student_id INT NOT NULL,
    is_main_staff BOOLEAN NOT NULL DEFAULT FALSE,
    main_role VARCHAR(50),
    has_resigned BOOLEAN NOT NULL DEFAULT FALSE,
    resign_description TEXT,
    resign_time TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (cohort_id) REFERENCES cohorts(cohort_id) ON DELETE CASCADE
);