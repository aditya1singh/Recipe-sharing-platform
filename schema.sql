-- =====================================================================
-- FitCoach Database Schema (MySQL)
-- Tech: Plain JDBC (PreparedStatement only, No ORM)
-- Project: FitCoach - Online Fitness Coaching Platform (GUVI x HCL Review 1)
-- =====================================================================

DROP DATABASE IF EXISTS fitcoach_db;
CREATE DATABASE fitcoach_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE fitcoach_db;

-- 1. USERS TABLE
-- Core user entity supporting roles: CLIENT, COACH, ADMIN
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL, -- Stored as SHA-256 Hex Hash (never plaintext)
    phone VARCHAR(20),
    role ENUM('CLIENT', 'COACH', 'ADMIN') NOT NULL DEFAULT 'CLIENT',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_user_email (email),
    INDEX idx_user_role (role)
) ENGINE=InnoDB;

-- 2. COACH PROFILES TABLE
-- Extended coach details linked to user (1-to-1 relationship)
CREATE TABLE coach_profiles (
    profile_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    specialization VARCHAR(150) NOT NULL, -- e.g. Hypertrophy, Weight Loss, HIIT, Yoga
    experience_years INT NOT NULL DEFAULT 1,
    bio TEXT,
    hourly_rate DECIMAL(10, 2) DEFAULT 0.00,
    certification VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 3. WORKOUT PROGRAMS TABLE
-- Created by coaches or admins, browsable and enrollable by clients
CREATE TABLE programs (
    program_id INT AUTO_INCREMENT PRIMARY KEY,
    coach_id INT NOT NULL,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    category VARCHAR(60) NOT NULL, -- Strength, Fat Loss, Cardio, Mobility, Nutrition
    difficulty ENUM('BEGINNER', 'INTERMEDIATE', 'ADVANCED') NOT NULL DEFAULT 'BEGINNER',
    duration_weeks INT NOT NULL DEFAULT 4,
    price DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (coach_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_program_category (category)
) ENGINE=InnoDB;

-- 4. ENROLLMENTS TABLE
-- M-to-N relationship between clients and programs
CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT NOT NULL,
    program_id INT NOT NULL,
    enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('ACTIVE', 'COMPLETED', 'CANCELLED') NOT NULL DEFAULT 'ACTIVE',
    payment_status ENUM('PAID', 'PENDING') NOT NULL DEFAULT 'PAID',
    FOREIGN KEY (client_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (program_id) REFERENCES programs(program_id) ON DELETE CASCADE,
    UNIQUE KEY uq_client_program (client_id, program_id)
) ENGINE=InnoDB;

-- 5. SESSIONS (BOOKINGS) TABLE
-- 1-on-1 coaching consultations between client and coach
CREATE TABLE sessions (
    session_id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT NOT NULL,
    coach_id INT NOT NULL,
    session_title VARCHAR(150) NOT NULL,
    session_time DATETIME NOT NULL,
    duration_minutes INT DEFAULT 45,
    status ENUM('SCHEDULED', 'COMPLETED', 'CANCELLED') DEFAULT 'SCHEDULED',
    meeting_link VARCHAR(255),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (client_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (coach_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 6. WORKOUT / DIET PLANS TABLE
-- Tailored routines assigned to clients by coaches
CREATE TABLE workout_plans (
    plan_id INT AUTO_INCREMENT PRIMARY KEY,
    program_id INT,
    coach_id INT NOT NULL,
    client_id INT NOT NULL,
    plan_name VARCHAR(150) NOT NULL,
    day_of_week VARCHAR(20) NOT NULL, -- Monday, Tuesday, etc.
    exercise_details TEXT NOT NULL,
    diet_instructions TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (program_id) REFERENCES programs(program_id) ON DELETE SET NULL,
    FOREIGN KEY (coach_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (client_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 7. PROGRESS LOGS TABLE
-- Client updates: weight, workout completed, mood, notes
CREATE TABLE progress_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT NOT NULL,
    log_date DATE NOT NULL,
    weight_kg DECIMAL(5, 2),
    workout_completed VARCHAR(150),
    calories_burned INT DEFAULT 0,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (client_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- =====================================================================
-- SAMPLE SEED DATA (All passwords are hashed with SHA-256 for: 'Password@123')
-- SHA-256 of "Password@123" = ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f
-- =====================================================================

-- Seed Users (1 Admin, 2 Coaches, 2 Clients)
INSERT INTO users (user_id, full_name, email, password_hash, phone, role) VALUES
(1, 'System Administrator', 'admin@fitcoach.com', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', '+91 9876543210', 'ADMIN'),
(2, 'Marcus Vance', 'coach.marcus@fitcoach.com', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', '+91 9876543211', 'COACH'),
(3, 'Elena Rostova', 'coach.elena@fitcoach.com', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', '+91 9876543212', 'COACH'),
(4, 'Rahul Sharma', 'rahul@client.com', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', '+91 9876543213', 'CLIENT'),
(5, 'Priya Patel', 'priya@client.com', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', '+91 9876543214', 'CLIENT');

-- Seed Coach Profiles
INSERT INTO coach_profiles (profile_id, user_id, specialization, experience_years, bio, hourly_rate, certification) VALUES
(1, 2, 'Strength & Hypertrophy', 8, 'Elite bodybuilding and progressive overload coach. Helped 300+ athletes build muscle and discipline.', 49.99, 'CSCS Certified, ACE Fitness'),
(2, 3, 'HIIT, Fat Loss & Mobility', 6, 'Former gymnast specializing in functional fitness, metabolic conditioning, and sustainable nutrition.', 39.99, 'NASM-CPT, Precision Nutrition L1');

-- Seed Programs
INSERT INTO programs (program_id, coach_id, title, description, category, difficulty, duration_weeks, price) VALUES
(1, 2, 'Hypertrophy Beast 12-Week', 'Progressive compound lifting program designed to maximize muscle growth and strength foundations.', 'Strength', 'INTERMEDIATE', 12, 79.99),
(2, 2, 'Beginner Barbell Blueprint', 'Step-by-step introduction to squat, bench press, deadlift, and overhead press with safe form.', 'Strength', 'BEGINNER', 6, 39.99),
(3, 3, 'Metabolic Shred & HIIT', 'High intensity conditioning workouts combined with calorie-burning circuit training.', 'Fat Loss', 'ADVANCED', 8, 59.99),
(4, 3, 'Core Stability & Mobility Flow', 'Rehabilitate tight hips, correct posture, and build an unbreakable abdominal core.', 'Mobility', 'BEGINNER', 4, 29.99);

-- Seed Enrollments
INSERT INTO enrollments (enrollment_id, client_id, program_id, status, payment_status) VALUES
(1, 4, 1, 'ACTIVE', 'PAID'),
(2, 4, 3, 'ACTIVE', 'PAID'),
(3, 5, 4, 'ACTIVE', 'PAID');

-- Seed Sessions
INSERT INTO sessions (session_id, client_id, coach_id, session_title, session_time, duration_minutes, status, meeting_link, notes) VALUES
(1, 4, 2, 'Form Check: Squats & Deadlifts', DATE_ADD(NOW(), INTERVAL 2 DAY), 45, 'SCHEDULED', 'https://meet.jit.si/fitcoach-session-101', 'Bring workout shoes and record video from side angle.'),
(2, 5, 3, 'Mobility Assessment & Posture Drill', DATE_ADD(NOW(), INTERVAL 3 DAY), 45, 'SCHEDULED', 'https://meet.jit.si/fitcoach-session-102', 'Focus on anterior pelvic tilt and thoracic spine.');

-- Seed Workout Plans
INSERT INTO workout_plans (plan_id, program_id, coach_id, client_id, plan_name, day_of_week, exercise_details, diet_instructions) VALUES
(1, 1, 2, 4, 'Heavy Lower Body Push', 'Monday', 'Back Squats 4x6 @ RPE 8, Romanian Deadlift 3x8, Bulgarian Split Squat 3x10, Standing Calf Raises 4x15', 'Pre-workout: 40g carbs + 20g protein. Post-workout: High protein shake with banana.'),
(2, 4, 3, 5, 'Hip Opener & Core Awakening', 'Wednesday', '90/90 Hip Switches 3x10, Cat-Cow 2 mins, Bird-Dog 3x12/side, Dead Bug 3x10, Plank Hold 3x45s', 'Hydrate with electrolytes. Keep calories at maintenance with anti-inflammatory foods.');

-- Seed Progress Logs
INSERT INTO progress_logs (log_id, client_id, log_date, weight_kg, workout_completed, calories_burned, notes) VALUES
(1, 4, DATE_SUB(CURDATE(), INTERVAL 4 DAY), 78.50, 'Leg Day (Squats & Deadlifts)', 450, 'Felt strong, added 5kg to squat!'),
(2, 4, DATE_SUB(CURDATE(), INTERVAL 2 DAY), 78.10, 'Upper Body Push (Bench & Shoulders)', 420, 'Slight fatigue in right tricep, stretched thoroughly.'),
(3, 5, DATE_SUB(CURDATE(), INTERVAL 1 DAY), 62.30, 'Mobility & 5k Brisk Walk', 310, 'Lower back stiffness significantly reduced.');
