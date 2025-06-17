CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(150) UNIQUE,
    phone VARCHAR(20),
    address TEXT
);


CREATE TABLE fees (
    fee_id SERIAL PRIMARY KEY,
    student_id INT REFERENCES students(student_id),
    amount_due NUMERIC(10,2),
    amount_paid NUMERIC(10,2),
    payment_date DATE DEFAULT CURRENT_DATE
);


CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    course_code VARCHAR(10) UNIQUE,
    course_name VARCHAR(100),
    credit_hours INT
);


CREATE TABLE course_enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INT REFERENCES students(student_id),
    course_id INT REFERENCES courses(course_id),
    enrollment_date DATE DEFAULT CURRENT_DATE
);

-- Lecturers Table
CREATE TABLE lecturers (
    lecturer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(150) UNIQUE
);


CREATE TABLE tas (
    ta_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(150) UNIQUE
);


CREATE TABLE lecturer_course (
    id SERIAL PRIMARY KEY,
    lecturer_id INT REFERENCES lecturers(lecturer_id),
    course_id INT REFERENCES courses(course_id)
);


CREATE TABLE lecturer_ta (
    id SERIAL PRIMARY KEY,
    lecturer_id INT REFERENCES lecturers(lecturer_id),
    ta_id INT REFERENCES tas(ta_id)
);

INSERT INTO students (first_name, last_name, email, phone, address) VALUES
('Haleem', 'Abdul', 'abdallahabdulhaleem@ug.edu.gh', '0244000000', 'Legon, Accra'),
('Ama', 'Adda', 'amaboateng@ug.edu.gh', '0244000001', 'Adenta, Accra'),
('Nana Yaw', 'Essilfie', 'essilfienanayaw@ug.edu.gh', '0244000002', 'Madina, Accra');


INSERT INTO fees (student_id, amount_due, amount_paid) VALUES
(1, 2000.00, 1500.00),
(2, 2000.00, 2000.00),
(3, 2000.00, 500.00);


INSERT INTO courses (course_code, course_name, credit_hours) VALUES
('CPEN201', 'Computer Architecture', 3),
('SENG207', 'Software Engineering', 3),
('MATH241', 'Discrete Math', 3);


INSERT INTO course_enrollments (student_id, course_id) VALUES
(1, 1), (1, 2),
(2, 1), (2, 3),
(3, 2), (3, 3);

-- Lecturers
INSERT INTO lecturers (first_name, last_name, email) VALUES
('Dr.', 'Aboagye', 'aboagye@ug.edu.gh'),
('Mr.', 'Assiamah', 'assiamah@ug.edu.gh');


INSERT INTO tas (first_name, last_name, email) VALUES
('Samuel', 'Adjei', 'sadjei@ug.edu.gh'),
('Linda', 'Nartey', 'lnartey@ug.edu.gh');


INSERT INTO lecturer_course (lecturer_id, course_id) VALUES
(1, 1),
(2, 2),
(1, 3);


INSERT INTO lecturer_ta (lecturer_id, ta_id) VALUES
(1, 1),
(2, 2);

CREATE OR REPLACE FUNCTION get_outstanding_fees()
RETURNS JSON AS $$
DECLARE
    result JSON;
BEGIN
    SELECT json_agg(json_build_object(
        'student_id', s.student_id,
        'full_name', s.first_name || ' ' || s.last_name,
        'amount_due', f.amount_due,
        'amount_paid', f.amount_paid,
        'outstanding', f.amount_due - f.amount_paid
    ))
    INTO result
    FROM students s
    JOIN fees f ON s.student_id = f.student_id;

    RETURN result;
END;
$$ LANGUAGE plpgsql;

