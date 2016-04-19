-- Person
CLASS Person "Persons related to the company"
(
    person-id                                 : INTEGER, REQUIRED;
    first-name                                : STRING,  REQUIRED;
    last-name                                 : STRING,  REQUIRED;
    home_address                              : STRING;
    zipcode                                   : INTEGER;
    home-phone "Home phone number (optional)" : INTEGER;
    us-citizen "U.S. citizenship status"      : BOOLEAN, REQUIRED;

    spouse     "Person's spouse if married"   : Person,                       INVERSE IS spouse;
    children   "Person's children (optional)" : Person,  MV(DISTINCT),        INVERSE IS parents;
    parents    "Person's parents  (optional)" : Person,  MV(DISTINCT, MAX 2), INVERSE IS children;
);

-- Employee
SUBCLASS Employee "Current employees of the company" OF Person
(
    employee-id      "Unique employee identification"    : INTEGER, REQUIRED;
    salary           "Current yearly salary"             : INTEGER, REQUIRED;
    salary-exception "TRUE if salary can exceed maximum" : BOOLEAN;
    employee-manager "Employee's current manager"        : Manager, INVERSE IS employees-managing;
);

-- Project-Employee
SUBCLASS Project-Employee "Employees who are project team members" OF Employee
(
    current-projects "current project of employee" : Current-Project, MV (DISTINCT, MAX 6), INVERSE IS project-members;
);
-- Manager
SUBCLASS Manager "Managers of the company" OF Employee
(
    bonus              "Yearly bonus, if any"               : INTEGER;
    employees-managing "Employees reporting to manager"     : Employee,  MV, INVERSE IS employee-manager;
    projects-managing  "Projects responsible for"           : Project,   MV, INVERSE IS project-manager;
    manager-dept       "Department to which manager belong" : Department,    INVERSE IS dept-managers;
);

-- Interim-Manager
SUBCLASS Interim-Manager "Employees temporarily acting as a project employee and a manager" OF Manager AND Project-Employee();
-- President
SUBCLASS President "Current president of the company" OF Manager();
-- Previous-Employee
SUBCLASS Previous-Employee "Past employees of the company" OF Person
(
    IsFired                           : BOOLEAN;
    salary "Salary as of termination" : INTEGER, REQUIRED;
);

-- Project
CLASS Project "Current and completed Projects"
(
    project-no      "Unique project identification" : INTEGER,        REQUIRED;
    project-title   "Code name for project"         : STRING [20],    REQUIRED;
    project-manager "Current project manager"       : Manager,        INVERSE IS projects-managing;
    dept-assigned   "Responsible department"        : Department, SV, INVERSE IS project-at;
    sub-projects    "Component projects, if any"    : Project,    MV, INVERSE IS sub-project-of;
    sub-project-of  "Master project, if any"        : Project,        INVERSE IS sub-projects;
);

-- Current-Project
SUBCLASS Current-Project "Projects currently in progress" OF Project
(
    project-active "Whether project has been started" : BOOLEAN, REQUIRED;
    project-members "Current employees on project"    : Project-Employee, MV (DISTINCT, MAX 20), INVERSE IS current-projects;
);

-- Previous-Project
SUBCLASS Previous-Project "Completed Projects" OF Project
(
    end-date-month   "Date project completed month" : INTEGER;
    end-date-day     "Date project completed day"   : INTEGER;
    end-date-year    "Date project completed year"  : INTEGER;
    est-person-hours "Estimated hours to complete"  : INTEGER;
);

-- Department
CLASS Department "Departments within the company"
(
    dept-no       "Corporate department number"           : INTEGER,     REQUIRED;
    dept-name     "Corporate department name"             : STRING [20], REQUIRED;
    project-at    "Projects worked on at this department" : Project,  MV(DISTINCT), INVERSE IS dept-assigned;
    dept-managers "Managers for this department"          : Manager,  MV,           INVERSE IS manager-dept;
);
