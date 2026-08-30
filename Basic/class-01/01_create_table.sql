CREATE TABLE students (
    student_id SERIAL PRIMARY KEY, --serial: auto inceremented integer, pk: not null and unique
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50),

    email VARCHAR(322) UNIQUE NOT NULL,
    phone_number VARCHAR(10) UNIQUE,
    country_code VARCHAR(4),

    age INT CHECK (age > 12 AND age < 120),

    current_status VARCHAR(20) DEFAULT 'active' CHECK (current_status IN ('active', 'graduated', 'dropped_out')),

    twitter_handle VARCHAR(50) UNIQUE,

    has_joined_discord BOOLEAN DEFAULT FALSE,

    current_score INT DEFAULT 0 CHECK (current_score >= 0 AND current_score <= 100 ),

    enrollment_date DATE DEFAULT CURRENT_DATE -- this is just date: YYYY-MM-DD
    -- enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- this is along with time, by default it is UTC

);
