create database taskmanagement;

use taskmanagement;

-- Create Employee Table
CREATE TABLE IF NOT EXISTS employee (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255),
    role ENUM('ADMIN', 'EMPLOYEE')
);

-- Create Task Table
CREATE TABLE IF NOT EXISTS task (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255),
    description TEXT,
    status VARCHAR(50),
    employee_id BIGINT,
    FOREIGN KEY (employee_id) REFERENCES employee(id)
);

-- Insert Sample Employees (Admin and Employee)
INSERT INTO employee (name, email, role) VALUES
('John Doe', 'john@example.com', 'EMPLOYEE'),
('Jane Smith', 'jane@example.com', 'EMPLOYEE'),
('Admin User', 'admin@example.com', 'ADMIN');

-- Insert Sample Tasks
INSERT INTO task (title, description, status, employee_id) VALUES
('Design Website', 'Create website wireframes', 'Pending', 1),
('Develop Backend', 'Develop the REST API', 'In Progress', 2);
