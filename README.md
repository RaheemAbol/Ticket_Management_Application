# Ticket_Management_Application

### Ticket Breakdown for Ticket Management Application

---

### **Ticket 1: Set Up Project and Dependencies**

1. **Objective:**
   - Set up the Spring Boot project with necessary dependencies and configure the project to use MySQL.

2. **Steps:**
   - **Step 1:** Initialize the project using Spring Initializr.
     - Choose dependencies: 
       - Spring Web (for building the web layer).
       - Spring Data JPA (for database interactions).
       - Thymeleaf (for rendering views).
       - MySQL Driver (for database connectivity).
   - **Step 2:** Organize the project structure by creating the following packages:
     - `model` - for entity classes like `Employee` and `Task`.
     - `repository` - for Spring Data JPA repositories.
     - `service` - for service layer business logic.
     - `controller` - for controllers to handle web requests.

   - **Step 3:** Configure `application.properties` to connect to MySQL and enable JPA settings:
     ```properties
     spring.datasource.url=jdbc:mysql://localhost:3306/ticketmanagement
     spring.datasource.username=root
     spring.datasource.password=your_password
     spring.jpa.hibernate.ddl-auto=update
     spring.jpa.show-sql=true
     ```

   - **Step 4:** Run the application to make sure it's correctly set up and connects to the MySQL database.

---

### **Ticket 2: Create `Employee` and `Task` Models**

1. **Objective:**
   - Define the `Employee` and `Task` entities and establish relationships between them.

2. **Steps:**

   - **Employee Model:**
     - Create the `Employee` entity with fields:
       - `id` (Primary key).
       - `name` (Employee’s name).
       - `email` (Employee’s email).
       - `role` (Enum for distinguishing between Admin and Employee roles).
       - `tasks` (A one-to-many relationship with `Task`).
     - Example code for the `Employee` model:
       ```java
       @Entity
       @Data
       public class Employee {
           @Id
           @GeneratedValue(strategy = GenerationType.IDENTITY)
           private Long id;
           private String name;
           private String email;
           @Enumerated(EnumType.STRING)
           private Role role;
           @OneToMany(mappedBy = "employee", cascade = CascadeType.ALL)
           private List<Task> tasks;
       }
       ```

   - **Task Model:**
     - Create the `Task` entity with fields:
       - `id` (Primary key).
       - `title` (Task title).
       - `description` (Task description).
       - `status` (Task status such as "Pending", "In Progress", etc.).
       - `employee` (A many-to-one relationship with `Employee`).
     - Example code for the `Task` model:
       ```java
       @Entity
       @Data
       public class Task {
           @Id
           @GeneratedValue(strategy = GenerationType.IDENTITY)
           private Long id;
           private String title;
           private String description;
           @ManyToOne
           @JoinColumn(name = "employee_id")
           private Employee employee;
           private String status;
       }
       ```

---

### **Ticket 3: Implement `EmployeeService` and `TaskService`**

1. **Objective:**
   - Create service classes for `Employee` and `Task` to handle business logic and interact with repositories.

2. **Steps:**
   - **EmployeeService:**
     - Implement methods such as:
       - `saveEmployee(Employee employee)` for saving/updating employees.
       - `getAllEmployees()` for retrieving all employees.
       - `getEmployeeById(Long id)` for retrieving a specific employee by ID.
       - `deleteEmployee(Long id)` for deleting employees.
     - Inject `EmployeeRepository` into the service.

   - **TaskService:**
     - Implement methods such as:
       - `saveTask(Task task)` for saving/updating tasks.
       - `getAllTasks()` for retrieving all tasks.
       - `getTaskById(Long id)` for retrieving a task by ID.
       - `getTasksByEmployee(Employee employee)` for fetching tasks assigned to a specific employee.
       - `deleteTask(Long id)` for deleting tasks.
       - `updateTaskStatus(Long taskId, String status)` for updating task statuses.

---

### **Ticket 4: Create `EmployeeController` for Admin Employee Management**

1. **Objective:**
   - Build the controller to manage employee operations such as creating, editing, and deleting employees.

2. **Steps:**
   - **Step 1: View Employees:**
     - Add a `@GetMapping("/employees")` method to fetch and display all employees.
     ```java
     @GetMapping
     public String viewEmployees(Model model) {
         List<Employee> employees = employeeService.getAllEmployees();
         model.addAttribute("employees", employees);
         return "employee-list";
     }
     ```

   - **Step 2: Create New Employee:**
     - Add a `@GetMapping("/employees/new")` method to display the employee creation form.
     - Add a `@PostMapping("/employees/save")` method to save the new employee.
     ```java
     @PostMapping("/save")
     public String saveEmployee(@ModelAttribute("employee") Employee employee) {
         employeeService.saveEmployee(employee);
         return "redirect:/employees";
     }
     ```

   - **Step 3: Edit Employee:**
     - Add a `@GetMapping("/employees/edit/{id}")` method to display the edit form pre-filled with the employee's details.
     ```java
     @GetMapping("/edit/{id}")
     public String showEditEmployeeForm(@PathVariable Long id, Model model) {
         Employee employee = employeeService.getEmployeeById(id);
         model.addAttribute("employee", employee);
         return "employee-form";
     }
     ```

   - **Step 4: Delete Employee:**
     - Add a `@GetMapping("/employees/delete/{id}")` method to handle employee deletion.
     ```java
     @GetMapping("/delete/{id}")
     public String deleteEmployee(@PathVariable Long id) {
         employeeService.deleteEmployee(id);
         return "redirect:/employees";
     }
     ```

---

### **Ticket 5: Create `TaskController` for Admin Task Management**

1. **Objective:**
   - Build the controller to manage admin operations for tasks, such as creating, editing, and deleting tasks.

2. **Steps:**

   - **Step 1: List All Tasks:**
     - Add a `@GetMapping("/tasks")` method to list all tasks in the system.
     ```java
     @GetMapping
     public String listAllTasks(Model model) {
         List<Task> tasks = taskService.getAllTasks();
         model.addAttribute("tasks", tasks);
         return "task-list";
     }
     ```

   - **Step 2: Create New Task:**
     - Add a `@GetMapping("/tasks/new")` method to display a form for creating new tasks.
     - Add a `@PostMapping("/tasks/save")` method to save the new task.
     ```java
     @GetMapping("/new")
     public String showCreateTaskForm(Model model) {
         Task task = new Task();
         List<Employee> employees = employeeService.getAllEmployees();
         model.addAttribute("task", task);
         model.addAttribute("employees", employees);
         return "task-form";
     }
     ```

   - **Step 3: Edit Task:**
     - Add a `@GetMapping("/tasks/edit/{id}")` method to display a form for editing tasks.
     ```java
     @GetMapping("/edit/{id}")
     public String editTask(@PathVariable Long id, Model model) {
         Task task = taskService.getTaskById(id);
         model.addAttribute("task", task);
         return "task-form";
     }
     ```

   - **Step 4: Delete Task:**
     - Add a `@GetMapping("/tasks/delete/{id}")` method to handle task deletion.
     ```java
     @GetMapping("/delete/{id}")
     public String deleteTask(@PathVariable Long id) {
         taskService.deleteTask(id);
         return "redirect:/tasks";
     }
     ```

---

### **Ticket 6: Build Employee Task Hub**

1. **Objective:**
   - Implement a task hub where employees can view tasks assigned to them and update the task status.

2. **Steps:**

   - **Step 1: Employee Task Hub:**
     - Add a `@GetMapping("/tasks/employee")` method to display tasks assigned to the currently authenticated employee.
     ```java
     @GetMapping("/employee")
     public String employeeTaskHub(Model model) {
         Employee employee = getAuthenticatedEmployee();
         List<Task> tasks = taskService.getTasksByEmployee(employee);
         model.addAttribute("tasks", tasks);
         return "task-hub";
     }
     ```

   - **Step 2: Update Task Status:**
     - Add a `@PostMapping("/tasks/update-status")` method to handle employee status updates.
     ```java
     @PostMapping("/update-status")
     public String updateTaskStatus(@RequestParam Long taskId, @RequestParam String status) {
         Employee employee = getAuthenticatedEmployee();
         Task task = taskService.getTaskById(taskId);
         if (task != null && task.getEmployee().getId().equals

      (employee.getId())) {
             taskService.updateTaskStatus(taskId, status);
         }
         return "redirect:/tasks/employee";
     }
     ```

---

Sure! Let's redo **Ticket 7** and **Ticket 8** with more detailed instructions and a step-by-step guide for the HTML structure and testing workflows.

---

### **Ticket 7: Build Thymeleaf Templates**

1. **Objective:**
   - Create Thymeleaf templates for managing employees and tasks. Provide most of the HTML structure, and allow the user to fill in specific Thymeleaf expressions where necessary.

2. **Steps:**

   - **Step 1: Create Employee List Template (`employee-list.html`)**
     - This template displays a list of all employees with options to edit or delete each employee and a button to create a new employee.
     - HTML Structure:
       ```html
       <!DOCTYPE html>
       <html xmlns:th="http://www.thymeleaf.org">
       <head>
           <title>Employee List</title>
       </head>
       <body>
           <h1>Employee List</h1>
           <a th:href="@{/employees/new}">Create New Employee</a>
           <table>
               <thead>
                   <tr>
                       <th>Name</th>
                       <th>Email</th>
                       <th>Actions</th>
                   </tr>
               </thead>
               <tbody>
                   <!-- Thymeleaf loop goes here -->
                   <tr th:each="employee : ${employees}">
                       <td th:text="${employee.name}">Employee Name</td>
                       <td th:text="${employee.email}">Employee Email</td>
                       <td>
                           <a th:href="@{/employees/edit/{id}(id=${employee.id})}">Edit</a>
                           <a th:href="@{/employees/delete/{id}(id=${employee.id})}">Delete</a>
                       </td>
                   </tr>
               </tbody>
           </table>
       </body>
       </html>
       ```
     - **Explanation:**
       - The `th:each` loop iterates over the `employees` passed from the controller.
       - The `th:text` attributes bind employee names and emails to the table.
       - Links for edit and delete actions include the `id` of the employee.

   - **Step 2: Create Employee Form Template (`employee-form.html`)**
     - This template is used to create or edit an employee. It contains form inputs for name, email, and role.
     - HTML Structure:
       ```html
       <!DOCTYPE html>
       <html xmlns:th="http://www.thymeleaf.org">
       <head>
           <title>Create or Edit Employee</title>
       </head>
       <body>
           <h1 th:text="${employee.id != null ? 'Edit Employee' : 'Create Employee'}"></h1>
           <form th:action="@{/employees/save}" th:object="${employee}" method="post">
               <input type="hidden" th:field="*{id}" />
               <label for="name">Name</label>
               <input type="text" id="name" th:field="*{name}" required />
               <label for="email">Email</label>
               <input type="email" id="email" th:field="*{email}" required />
               <label for="role">Role</label>
               <select id="role" th:field="*{role}" required>
                   <option th:value="ADMIN">Admin</option>
                   <option th:value="EMPLOYEE">Employee</option>
               </select>
               <button type="submit">Save Employee</button>
           </form>
           <a th:href="@{/employees}">Back to Employee List</a>
       </body>
       </html>
       ```
     - **Explanation:**
       - This template uses `th:object="${employee}"` to bind the form fields to the `Employee` object.
       - It uses a conditional title (`th:text`) to show either "Edit Employee" or "Create Employee" based on whether the `employee.id` is present.
       - After submitting, the form redirects back to the employee list.

   - **Step 3: Create Task List Template (`task-list.html`)**
     - This template shows a list of all tasks with options to edit or delete each task and a button to create a new task.
     - HTML Structure:
       ```html
       <!DOCTYPE html>
       <html xmlns:th="http://www.thymeleaf.org">
       <head>
           <title>Task List</title>
       </head>
       <body>
           <h1>Task List</h1>
           <a th:href="@{/tasks/new}">Create New Task</a>
           <table>
               <thead>
                   <tr>
                       <th>Title</th>
                       <th>Description</th>
                       <th>Status</th>
                       <th>Assigned Employee</th>
                       <th>Actions</th>
                   </tr>
               </thead>
               <tbody>
                   <!-- Thymeleaf loop goes here -->
                   <tr th:each="task : ${tasks}">
                       <td th:text="${task.title}">Task Title</td>
                       <td th:text="${task.description}">Task Description</td>
                       <td th:text="${task.status}">Task Status</td>
                       <td th:text="${task.employee.name}">Assigned Employee</td>
                       <td>
                           <a th:href="@{/tasks/edit/{id}(id=${task.id})}">Edit</a>
                           <a th:href="@{/tasks/delete/{id}(id=${task.id})}">Delete</a>
                       </td>
                   </tr>
               </tbody>
           </table>
       </body>
       </html>
       ```
     - **Explanation:**
       - The `th:each` loop iterates over the `tasks` passed from the controller.
       - Task details such as title, description, status, and assigned employee are displayed in the table.

   - **Step 4: Create Task Form Template (`task-form.html`)**
     - This template is used to create or edit a task. It includes form fields for the task title, description, employee assignment, and status.
     - HTML Structure:
       ```html
       <!DOCTYPE html>
       <html xmlns:th="http://www.thymeleaf.org">
       <head>
           <title>Create or Edit Task</title>
       </head>
       <body>
           <h1 th:text="${task != null && task.id != null ? 'Edit Task' : 'Create Task'}"></h1>
           <form th:action="@{/tasks/save}" th:object="${task}" method="post">
               <input type="hidden" th:field="*{id}" />
               <label for="title">Title</label>
               <input type="text" th:field="*{title}" id="title" required />
               <label for="description">Description</label>
               <textarea th:field="*{description}" id="description"></textarea>
               <label for="employee">Assign to Employee</label>
               <select th:field="*{employee.id}" id="employee" required>
                   <option th:each="employee : ${employees}" th:value="${employee.id}" th:text="${employee.name}"></option>
               </select>
               <label for="status">Status</label>
               <select th:field="*{status}" id="status" required>
                   <option value="Pending">Pending</option>
                   <option value="In Progress">In Progress</option>
                   <option value="Review">Review</option>
                   <option value="Complete">Complete</option>
               </select>
               <button type="submit">Save Task</button>
           </form>
           <a th:href="@{/tasks}">Back to Task List</a>
       </body>
       </html>
       ```
     - **Explanation:**
       - This template binds the form fields to the `Task` object.
       - The employee dropdown dynamically populates with employees retrieved from the controller.

   - **Step 5: Create Employee Task Hub Template (`task-hub.html`)**
     - This template is used by employees to view tasks assigned to them and update their statuses.
     - HTML Structure:
       ```html
       <!DOCTYPE html>
       <html xmlns:th="http://www.thymeleaf.org">
       <head>
           <title>Task Hub</title>
       </head>
       <body>
           <h1>Task Hub for <span th:text="${employee.name}"></span></h1>
           <table>
               <thead>
                   <tr>
                       <th>Title</th>
                       <th>Description</th>
                       <th>Status</th>
                       <th>Action</th>
                   </tr>
               </thead>
               <tbody>
                   <!-- Thymeleaf loop goes here -->
                   <tr th:each="task : ${tasks}">
                       <td th:text="${task.title}"></td>
                       <td th:text="${task.description}"></td>
                       <td th:text="${task.status}"></td>
                       <td>
                           <form th:action="@{/tasks/update-status}" method="post">
                               <input type="hidden" name="taskId" th:value="${task.id}">
                               <select name="status">
                                   <option th:selected="${task.status == 'Pending'}" value="Pending">Pending</option>
                                   <option th:selected="${task.status == 'In Progress'}" value="In Progress">In Progress</option>
                                   <option th:selected="${task.status == 'Review'}" value="Review">Review</option>
                                   <option th:selected="${task.status == 'Complete'}" value="Complete">Complete</option>
                               </select>
                              

          <button type="submit">Update Status</button>
                           </form>
                       </td>
                   </tr>
               </tbody>
           </table>
           <a th:href="@{/tasks}">Back to Task List</a>
       </body>
       </html>
       ```
     - **Explanation:**
       - Employees can view the tasks assigned to them and use the dropdown to update task status.

---

### **Ticket 8: Test and Populate Data**

1. **Objective:**
   - Test the entire application workflow by populating the database with sample data and walking through the Admin and Employee workflows.

2. **Steps:**

   - **Step 1: Populate the Database with Sample Data**
     - Use the following SQL script to insert sample data for testing:
       ```sql
       -- Insert Employees
       INSERT INTO employee (name, email, role) VALUES 
       ('Admin User', 'admin@example.com', 'ADMIN'),
       ('Employee One', 'employee1@example.com', 'EMPLOYEE'),
       ('Employee Two', 'employee2@example.com', 'EMPLOYEE');

       -- Insert Tasks
       INSERT INTO task (title, description, employee_id, status) VALUES 
       ('Task 1', 'Description of Task 1', 2, 'Pending'),
       ('Task 2', 'Description of Task 2', 3, 'In Progress'),
       ('Task 3', 'Description of Task 3', 2, 'Complete');
       ```
     - **Explanation:**
       - Three employees are inserted: one admin and two regular employees.
       - Three tasks are assigned to the employees, with varying statuses.

   - **Step 2: Test Admin Workflow**
     - **Objective:**
       - Test the admin's ability to manage employees and tasks.
     - **Steps:**
       1. Simulate admin login by ensuring `isAuthenticatedAdmin()` returns `true`.
       2. **Employee Management:**
          - Navigate to `/employees`.
          - Verify that all employees are listed.
          - Create a new employee by clicking "Create New Employee."
          - Edit an existing employee by clicking "Edit" next to one of the employees.
          - Delete an employee and ensure they are removed from the list.
       3. **Task Management:**
          - Navigate to `/tasks`.
          - Verify that all tasks are listed.
          - Create a new task by clicking "Create New Task."
          - Edit an existing task by clicking "Edit" next to one of the tasks.
          - Delete a task and ensure it is removed from the list.

   - **Step 3: Test Employee Workflow**
     - **Objective:**
       - Test the employee's ability to view and update tasks assigned to them.
     - **Steps:**
       1. Simulate employee login by changing `getAuthenticatedEmployee()` to return either `Employee One` or `Employee Two`.
       2. **Task Hub:**
          - Navigate to `/tasks/employee`.
          - Verify that only the tasks assigned to the logged-in employee are displayed.
          - Use the dropdown to change the status of a task and submit the form.
          - Ensure that the status of the task is updated in the database.
          - Repeat for other tasks assigned to the employee.

---

