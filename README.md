# Ticket_Management_Application

### **Ticket Breakdown**

---

### **Ticket 1: Set Up Project and Dependencies**

1. **Objective:**
   - Set up the Spring Boot project with the required dependencies and configure it for MySQL.

2. **Steps:**
   - **Initialize the project** using Spring Initializr with the following dependencies:
     - Spring Web
     - Spring Data JPA
     - Thymeleaf
     - MySQL Driver
   - Create the following packages for organization:
     - `model` (for entity classes)
     - `repository` (for Spring Data JPA repositories)
     - `service` (for service layer)
     - `controller` (for controllers)
   - Add MySQL configuration in `application.properties`:
     ```properties
     spring.datasource.url=jdbc:mysql://localhost:3306/taskmanagement
     spring.datasource.username=root
     spring.datasource.password=password
     spring.jpa.hibernate.ddl-auto=update
     spring.jpa.show-sql=true
     ```
   - 

---

### **Ticket 2: Create `Employee` and `Task` Models**

1. **Objective:**
   - Define the `Employee` and `Task` entities, ensuring the correct relationships between them are established.

2. **Steps:**
   - **Employee Model:**
     - Create the `Employee` entity with the following fields:
       - `id`: Primary key, auto-increment.
       - `name`: Employee’s name.
       - `email`: Employee’s email.
       - `role`: Enum (`ADMIN`, `EMPLOYEE`) to differentiate between Admin and Employee users.
       - A `OneToMany` relationship to `Task`.

     **Example:**
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
     - Create the `Task` entity with the following fields:
       - `id`: Primary key, auto-increment.
       - `title`: Title of the task.
       - `description`: Task description.
       - `status`: Task status (e.g., `Pending`, `In Progress`, `Complete`).
       - `employee`: A `ManyToOne` relationship to `Employee`.

     **Example:**
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
   - Build the service layer for `Employee` and `Task` that handles business logic and interaction with the repository.

2. **Steps:**
   - **EmployeeService**:
     - Create methods to manage employee data:
       - `saveEmployee(Employee employee)` for saving/updating employees.
       - `getAllEmployees()` for retrieving all employees.
       - `getEmployeeById(Long id)` for fetching a specific employee.
       - `deleteEmployee(Long id)` for deleting an employee.
     - Inject `EmployeeRepository` into the service.

   - **TaskService**:
     - Create methods to manage tasks:
       - `saveTask(Task task)` for saving/updating tasks.
       - `getAllTasks()` for retrieving all tasks.
       - `getTaskById(Long id)` for fetching a specific task.
       - `getTasksByEmployee(Employee employee)` for retrieving tasks assigned to an employee.
       - `deleteTask(Long id)` for deleting a task.
       - `updateTaskStatus(Long taskId, String status)` for updating task status.
     - Inject `TaskRepository` into the service.

---

### **Ticket 4: Create `EmployeeController` for Admin Employee Management**

1. **Objective:**
   - Build the `EmployeeController` to handle Admin operations for creating, editing, and deleting employees.

2. **Steps:**

   - **Step 1: List Employees**
     - Add `@GetMapping("/employees")` method to fetch and display all employees on the employee-list.html page.
     - Example:
       ```java
       @GetMapping("/employees")
       public String viewEmployees(Model model) {
           List<Employee> employees = employeeService.getAllEmployees();
           model.addAttribute("employees", employees);
           return "employee-list";
       }
       ```

   - **Step 2: Create New Employee**
     - Add `@GetMapping("/employees/new")` to show a form for creating a new employee.
     - Add `@PostMapping("/employees/save")` to handle saving a new employee.
     - Simulate Admin authentication with the `isAuthenticatedAdmin()` method.
     - Example:
       ```java
       @PostMapping("/employees/save")
       public String saveEmployee(@ModelAttribute("employee") Employee employee) {
           if (!isAuthenticatedAdmin()) {
               return "error/403";
           }
           employeeService.saveEmployee(employee);
           return "redirect:/employees";
       }
       ```

   - **Step 3: Edit Employee**
     - Add `@GetMapping("/employees/edit/{id}")` to show a form for editing an existing employee.
     - Fetch the employee by ID and populate the form with the employee’s data.
     - Example:
       ```java
       @GetMapping("/employees/edit/{id}")
       public String showEditEmployeeForm(@PathVariable Long id, Model model) {
           Employee employee = employeeService.getEmployeeById(id);
           model.addAttribute("employee", employee);
           return "employee-form";
       }
       ```

   - **Step 4: Delete Employee**
     - Add `@GetMapping("/employees/delete/{id}")` to handle deleting an employee by ID.
     - Example:
       ```java
       @GetMapping("/employees/delete/{id}")
       public String deleteEmployee(@PathVariable Long id) {
           employeeService.deleteEmployee(id);
           return "redirect:/employees";
       }
       ```

   - **Simulate Admin Access**:
     - Use the `isAuthenticatedAdmin()` method to restrict access to Admin-only actions.

---

### **Ticket 5: Create `TaskController` for Admin Task Management**

1. **Objective:**
   - Build the `TaskController` to manage Admin operations for creating, editing, and deleting tasks.

2. **Steps:**

   - **Step 1: List All Tasks**
     - Add `@GetMapping("/tasks")` method to list all tasks assigned to employees on the task-list.html page.
     - Fetch all tasks using `taskService.getAllTasks()`.
     - Example:
       ```java
       @GetMapping("/tasks")
       public String listAllTasks(Model model) {
           if (!isAuthenticatedAdmin()) {
               return "error/403";
           }
           List<Task> tasks = taskService.getAllTasks();
           model.addAttribute("tasks", tasks);
           return "task-list";
       }
       ```

   - **Step 2: Create New Task**
     - Add `@GetMapping("/tasks/new")` to show a form for creating a new task.
     - Fetch all employees using `employeeService.getAllEmployees()` to assign the task to.
     - Example:
       ```java
       @GetMapping("/tasks/new")
       public String showCreateTaskForm(Model model) {
           Task task = new Task();
           List<Employee> employees = employeeService.getAllEmployees();
           model.addAttribute("task", task);
           model.addAttribute("employees", employees);
           return "task-form";
       }
       ```

   - **Step 3: Edit Task**
     - Add `@GetMapping("/tasks/edit/{id}")` to show a form for editing an existing task.
     - Example:
       ```java
       @GetMapping("/tasks/edit/{id}")
       public String editTask(@PathVariable Long id, Model model) {
           Task task = taskService.getTaskById(id);
           List<Employee> employees = employeeService.getAllEmployees();
           model.addAttribute("task", task);
           model.addAttribute("employees", employees);
           return "task-form";
       }
       ```

   - **Step 4: Delete Task**
     - Add `@GetMapping("/tasks/delete/{id}")` to handle deleting a task by ID.
     - Example:
       ```java
       @GetMapping("/tasks/delete/{id}")
       public String deleteTask(@PathVariable Long id) {
           taskService.deleteTask(id);
           return "redirect:/tasks";
       }
       ```

---

### **Ticket 6: Build Employee Task Hub**

1. **Objective:**
   - Build a task hub where employees can view and update the status of tasks assigned to them.

2. **Steps:**

   - **Step 1: Employee Task Hub**
     - Add `@GetMapping("/tasks/employee")` to show tasks assigned to the currently authenticated employee.
     - Use the `getAuthenticatedEmployee()` method to fetch tasks for the employee.
     - Example:
       ```java
       @GetMapping("/tasks/employee

")
       public String employeeTaskHub(Model model) {
           Employee employee = getAuthenticatedEmployee();
           List<Task> tasks = taskService.getTasksByEmployee(employee);
           model.addAttribute("tasks", tasks);
           model.addAttribute("employee", employee);
           return "task-hub";
       }
       ```

   - **Step 2: Update Task Status**
     - Add `@PostMapping("/tasks/update-status")` to handle task status updates by employees.
     - Ensure employees can only update tasks assigned to them by verifying task ownership.
     - Example:
       ```java
       @PostMapping("/tasks/update-status")
       public String updateTaskStatus(@RequestParam Long taskId, @RequestParam String status) {
           Employee employee = getAuthenticatedEmployee();
           Task task = taskService.getTaskById(taskId);
           if (task != null && task.getEmployee().getId().equals(employee.getId())) {
               taskService.updateTaskStatus(taskId, status);
           }
           return "redirect:/tasks/employee";
       }
       ```

---

### **Ticket 7: Create Thymeleaf Templates**

1. **Objective:**
   - Develop Thymeleaf templates for the employee list, task list, task form, and employee task hub.

2. **Steps:**

   - **Step 1: `employee-list.html`**
     - Create a page that displays a list of employees with edit and delete options for each.
     - Include a button to create a new employee.
     - Example:
       ```html
       <table>
           <tr th:each="employee : ${employees}">
               <td th:text="${employee.name}"></td>
               <td th:text="${employee.email}"></td>
               <td>
                   <a th:href="@{/employees/edit/{id}(id=${employee.id})}">Edit</a>
                   <a th:href="@{/employees/delete/{id}(id=${employee.id})}">Delete</a>
               </td>
           </tr>
       </table>
       ```

   - **Step 2: `task-list.html`**
     - Create a page for the admin to view all tasks, with options to edit or delete tasks.
     - Example:
       ```html
       <table>
           <tr th:each="task : ${tasks}">
               <td th:text="${task.title}"></td>
               <td th:text="${task.description}"></td>
               <td th:text="${task.status}"></td>
               <td th:text="${task.employee.name}"></td>
               <td>
                   <a th:href="@{/tasks/edit/{id}(id=${task.id})}">Edit</a>
                   <a th:href="@{/tasks/delete/{id}(id=${task.id})}">Delete</a>
               </td>
           </tr>
       </table>
       ```

   - **Step 3: `task-form.html`**
     - Create a form for creating or editing tasks.
     - The form should allow selecting an employee to assign the task and setting the task status.
     - Example:
       ```html
       <form th:action="@{/tasks/save}" th:object="${task}" method="post">
           <label for="title">Title</label>
           <input type="text" th:field="*{title}" required>
           <label for="description">Description</label>
           <textarea th:field="*{description}"></textarea>
           <label for="employee">Assign to Employee</label>
           <select th:field="*{employee.id}">
               <option th:each="employee : ${employees}" th:value="${employee.id}" th:text="${employee.name}"></option>
           </select>
           <label for="status">Status</label>
           <select th:field="*{status}">
               <option value="Pending">Pending</option>
               <option value="In Progress">In Progress</option>
               <option value="Review">Review</option>
               <option value="Complete">Complete</option>
           </select>
           <button type="submit">Save Task</button>
       </form>
       ```

   - **Step 4: `task-hub.html`**
     - Create a task hub where employees can view their tasks and update their statuses.
     - Example:
       ```html
       <table>
           <tr th:each="task : ${tasks}">
               <td th:text="${task.title}"></td>
               <td th:text="${task.description}"></td>
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
       </table>
       ```

---

### **Ticket 8: Populate Dummy Data for Testing**

1. **Objective:**
   - Provide SQL scripts to populate the database with dummy data to simulate both admin and employee workflows.

2. **SQL Data:**

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

3. **Testing Workflows:**

   - **Admin Workflow:**
     - Simulate as Admin by ensuring `isAuthenticatedAdmin()` returns `true`.
     - Navigate to `/tasks` to manage tasks (create, edit, delete).
     - Navigate to `/employees` to manage employees (create, edit, delete).

   - **Employee Workflow:**
     - Change `getAuthenticatedEmployee()` to return `Employee One` or `Employee Two`.
     - Navigate to `/tasks/employee` to view and update task statuses assigned to that employee.
     - Ensure employees can only update their own tasks.
