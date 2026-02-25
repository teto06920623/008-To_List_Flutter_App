# 📝 Flutter Task & Note Manager (Todoist Clone)

A modern, dynamic, and responsive To-Do List and Task Management application built with **Flutter**. This project features a custom UI inspired by top productivity apps, complete with local data persistence and dynamic state management.

## ✨ Features

- **Dynamic Note Management:** Seamlessly add, view, and delete notes.
- **Custom Interactive Drawer:** A beautifully designed side menu with a custom header, quick links (Inbox, Today, Upcoming), and an expandable Projects section.
- **Project Categorization:** Users can create new projects, which are assigned unique color indicators.
- **Drag & Drop Reordering:** Implemented `ReorderableListView` allowing users to intuitively reorder their projects.
- **Local Data Persistence:** Utilizes `SharedPreferences` and `JSON` encoding to save notes and projects securely on the device, ensuring no data is lost upon app restart.
- **Elegant Empty State:** A clean, user-friendly "All clear" screen guides new users when the task list is empty.

## 📸 Screenshots

|                                    Empty State (Zero Inbox)                                     |                                      Adding a New Note                                       |                                        Notes List View                                         |
| :---------------------------------------------------------------------------------------------: | :------------------------------------------------------------------------------------------: | :--------------------------------------------------------------------------------------------: |
| ![Empty State](https://github.com/user-attachments/assets/689ed59d-1271-478d-8ab2-8b1cf02c3398) | ![Add Note](https://github.com/user-attachments/assets/63a4ac0a-1dff-490c-944e-bfa00eac86b7) | ![Notes List](https://github.com/user-attachments/assets/c044b678-654c-4ecf-8ba3-14e0f8bde42a) |

|                                     Custom Navigation Drawer                                      |                                      Adding a New Project                                       |
| :-----------------------------------------------------------------------------------------------: | :---------------------------------------------------------------------------------------------: |
| ![Custom Drawer](https://github.com/user-attachments/assets/409d3f61-a7d7-4b4b-b2d3-bf6cac6e0e5c) | ![Add Project](https://github.com/user-attachments/assets/d45080e4-91a9-473f-919b-82fbedeea679) |

## 🛠️ Tech Stack & Tools

- **Framework:** Flutter / Dart
- **State Management:** `setState` (Ephemeral State)
- **Storage:** `shared_preferences` (Local Device Storage)
- **Data Format:** `dart:convert` (JSON Encoding/Decoding)

## 🚀 How to Run the Project

1. Clone the repository:
   ```bash
   git clone [https://github.com/your-username/your-repo-name.git](https://github.com/teto06920623/008-To_List_Flutter_App)
   ```
