<%@ page import="java.util.*, dao.UserDAO, model.User" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("../login.jsp?error=Unauthorized+Access");
        return;
    }

    // Handle form submission (POST)
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String action = request.getParameter("action");
        dao.UserDAO dao = new dao.UserDAO();

        if ("delete".equalsIgnoreCase(action)) {
            // Delete user
            String userIdStr = request.getParameter("user_id");
            if (userIdStr != null && !userIdStr.isEmpty()) {
                dao.deleteUser(Integer.parseInt(userIdStr));
            }
        } else {
            // Add or update user
            String userIdStr = request.getParameter("user_id");
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String role = request.getParameter("role");

            model.User user = new model.User();
            user.setUsername(username);
            user.setRole(role);

            if (password != null && !password.isEmpty()) {
                // 🔒 Hash password using SHA-256
                java.security.MessageDigest md = java.security.MessageDigest.getInstance("SHA-256");
                byte[] hashBytes = md.digest(password.getBytes("UTF-8"));
                StringBuilder sb = new StringBuilder();
                for (byte b : hashBytes) {
                    sb.append(String.format("%02x", b));
                }
                user.setPassword(sb.toString());
            }

            if (userIdStr == null || userIdStr.isEmpty()) {
                dao.insertUser(user);
            } else {
                user.setUserId(Integer.parseInt(userIdStr));
                dao.updateUser(user);
            }
        }
    }

    // Load users list for display (excluding admin)
    dao.UserDAO dao = new dao.UserDAO();
    List<User> userList = dao.getAllUsersExceptAdmin();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Users - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<jsp:include page="../sidebars/admin_sidebar.jsp" />
<div class="container mt-5" style="margin-left: 260px;">
    <h3 class="mb-4">👥 Manage Users</h3>

    <!-- Add New User Button -->
    <button class="btn btn-primary mb-3" data-bs-toggle="modal" data-bs-target="#addUserModal" onclick="openAddUserModal()">➕ Add New User</button>

    <!-- Users Table -->
    <div class="table-responsive">
        <table class="table table-bordered align-middle">
            <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Username</th>
                    <th>Role</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% for (User u : userList) { %>
                <tr>
                    <td><%= u.getUserId() %></td>
                    <td><%= u.getUsername() %></td>
                    <td><%= u.getRole() %></td>
                    <td>
                        <button class="btn btn-sm btn-warning"
                            onclick="openEditUserModal(<%= u.getUserId() %>, '<%= u.getUsername() %>', '<%= u.getRole() %>')">Edit</button>

                        <form method="post" action="manage_users.jsp" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this user?');">
                            <input type="hidden" name="user_id" value="<%= u.getUserId() %>">
                            <input type="hidden" name="action" value="delete">
                            <button type="submit" class="btn btn-sm btn-danger">Delete</button>
                        </form>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<!-- Add User Modal -->
<div class="modal fade" id="addUserModal" tabindex="-1" aria-labelledby="addUserModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <form method="post" action="manage_users.jsp">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addUserModalLabel">Add New User</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" name="user_id" id="add_user_id">
                <div class="mb-3">
                    <label class="form-label">👤 Username</label>
                    <input type="text" class="form-control" name="username" id="add_username" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">🔒 Password</label>
                    <input type="password" class="form-control" name="password" id="add_password" required>
                    <!-- No "Leave blank" hint here -->
                </div>
                <div class="mb-3">
                    <label class="form-label">🛠️ Role</label>
                    <select class="form-select" name="role" id="add_role" required>
                        <option value="cashier">Cashier</option>
                        <option value="storekeeper">Store Keeper</option>
                    </select>
                </div>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-success">Add User</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
            </div>
        </div>
    </form>
  </div>
</div>

<!-- Edit User Modal -->
<div class="modal fade" id="editUserModal" tabindex="-1" aria-labelledby="editUserModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <form method="post" action="manage_users.jsp">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editUserModalLabel">Edit User</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" name="user_id" id="edit_user_id">
                <div class="mb-3">
                    <label class="form-label">👤 Username</label>
                    <input type="text" class="form-control" name="username" id="edit_username" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">🔒 Password</label>
                    <input type="password" class="form-control" name="password" id="edit_password">
                    <div class="form-text">Leave blank to keep current password (on edit)</div>
                </div>
                <div class="mb-3">
                    <label class="form-label">🛠️ Role</label>
                    <select class="form-select" name="role" id="edit_role" required>
                        <option value="cashier">Cashier</option>
                        <option value="storekeeper">Store Keeper</option>
                    </select>
                </div>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-success">Save Changes</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
            </div>
        </div>
    </form>
  </div>
</div>

<jsp:include page="../common/footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    let addUserModalInstance = null;
    let editUserModalInstance = null;

    function openAddUserModal() {
        document.getElementById("addUserModalLabel").innerText = "Add New User";
        document.getElementById("add_user_id").value = "";
        document.getElementById("add_username").value = "";
        document.getElementById("add_password").value = "";
        document.getElementById("add_role").value = "cashier";

        const modalEl = document.getElementById("addUserModal");
        addUserModalInstance = bootstrap.Modal.getOrCreateInstance(modalEl);
        addUserModalInstance.show();
    }

    function openEditUserModal(id, username, role) {
        document.getElementById("editUserModalLabel").innerText = "Edit User";
        document.getElementById("edit_user_id").value = id;
        document.getElementById("edit_username").value = username;
        document.getElementById("edit_password").value = "";
        document.getElementById("edit_role").value = role;

        const modalEl = document.getElementById("editUserModal");
        editUserModalInstance = bootstrap.Modal.getOrCreateInstance(modalEl);
        editUserModalInstance.show();
    }
</script>
</body>
</html>
