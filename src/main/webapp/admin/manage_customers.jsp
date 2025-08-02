<%@ page import="java.util.*, dao.CustomerDAO, model.Customer" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("../login.jsp?error=Unauthorized+Access");
        return;
    }

    // Handle delete first
    String deleteIdStr = request.getParameter("delete_customer_id");
    if (deleteIdStr != null) {
        int deleteId = Integer.parseInt(deleteIdStr);
        dao.CustomerDAO daoDelete = new dao.CustomerDAO();
        daoDelete.deleteCustomer(deleteId);
        response.sendRedirect("manage_customers.jsp"); // Redirect after delete to avoid resubmission
        return;
    }

    // Handle form submission (POST) for add/update
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String customerIdStr = request.getParameter("customer_id");
        String firstName = request.getParameter("first_name");
        String lastName = request.getParameter("last_name");
        String address = request.getParameter("address");
        String telephone = request.getParameter("telephone");
        String email = request.getParameter("email");

        dao.CustomerDAO dao = new dao.CustomerDAO();
        model.Customer customer = new model.Customer();

        customer.setFirstName(firstName);
        customer.setLastName(lastName);
        customer.setAddress(address);
        customer.setTelephone(telephone);
        customer.setEmail(email);

        if (customerIdStr == null || customerIdStr.isEmpty()) {
            dao.insertCustomer(customer);
        } else {
            customer.setCustomerId(Integer.parseInt(customerIdStr));
            dao.updateCustomer(customer);
        }
    }

    dao.CustomerDAO dao = new dao.CustomerDAO();
    List<Customer> customerList = dao.getAllCustomers();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Customers - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<jsp:include page="../sidebars/admin_sidebar.jsp" />
<div class="container mt-5" style="margin-left: 260px;">
    <h3 class="mb-4">👥 Manage Customers</h3>

    <!-- Add New Customer Button -->
    <button class="btn btn-primary mb-3" data-bs-toggle="modal" data-bs-target="#addCustomerModal" onclick="openAddCustomerModal()">➕ Add New Customer</button>

    <!-- Customers Table -->
    <div class="table-responsive">
        <table class="table table-bordered align-middle">
            <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>First Name</th>
                    <th>Last Name</th>
                    <th>Address</th>
                    <th>Telephone</th>
                    <th>Email</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% for (Customer c : customerList) { %>
                <tr>
                    <td><%= c.getCustomerId() %></td>
                    <td><%= c.getFirstName() %></td>
                    <td><%= c.getLastName() %></td>
                    <td><%= c.getAddress() %></td>
                    <td><%= c.getTelephone() %></td>
                    <td><%= c.getEmail() %></td>
                    <td>
                        <button class="btn btn-sm btn-warning"
                            onclick="openEditCustomerModal(<%= c.getCustomerId() %>, '<%= c.getFirstName() %>', '<%= c.getLastName() %>', '<%= c.getAddress() %>', '<%= c.getTelephone() %>', '<%= c.getEmail() %>')">Edit</button>
                        <form method="post" action="manage_customers.jsp" style="display:inline;" onsubmit="return confirm('Delete this customer?');">
                            <input type="hidden" name="delete_customer_id" value="<%= c.getCustomerId() %>">
                            <button type="submit" class="btn btn-sm btn-danger">Delete</button>
                        </form>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<!-- Add Customer Modal -->
<div class="modal fade" id="addCustomerModal" tabindex="-1" aria-labelledby="addCustomerModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <form method="post" action="manage_customers.jsp">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addCustomerModalLabel">Add New Customer</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" name="customer_id" id="add_customer_id">
                <div class="mb-3">
                    <label class="form-label">First Name</label>
                    <input type="text" class="form-control" name="first_name" id="add_first_name" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Last Name</label>
                    <input type="text" class="form-control" name="last_name" id="add_last_name" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Address</label>
                    <input type="text" class="form-control" name="address" id="add_address" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Telephone</label>
                    <input type="text" class="form-control" name="telephone" id="add_telephone" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <input type="email" class="form-control" name="email" id="add_email" required>
                </div>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-success">Add Customer</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
            </div>
        </div>
    </form>
  </div>
</div>

<!-- Edit Customer Modal -->
<div class="modal fade" id="editCustomerModal" tabindex="-1" aria-labelledby="editCustomerModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <form method="post" action="manage_customers.jsp">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editCustomerModalLabel">Edit Customer</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" name="customer_id" id="edit_customer_id">
                <div class="mb-3">
                    <label class="form-label">First Name</label>
                    <input type="text" class="form-control" name="first_name" id="edit_first_name" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Last Name</label>
                    <input type="text" class="form-control" name="last_name" id="edit_last_name" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Address</label>
                    <input type="text" class="form-control" name="address" id="edit_address" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Telephone</label>
                    <input type="text" class="form-control" name="telephone" id="edit_telephone" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <input type="email" class="form-control" name="email" id="edit_email" required>
                </div>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-success">Update Customer</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
            </div>
        </div>
    </form>
  </div>
</div>

<jsp:include page="../common/footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function openAddCustomerModal() {
        document.getElementById("addCustomerModalLabel").innerText = "Add New Customer";
        document.getElementById("add_customer_id").value = "";
        document.getElementById("add_first_name").value = "";
        document.getElementById("add_last_name").value = "";
        document.getElementById("add_address").value = "";
        document.getElementById("add_telephone").value = "";
        document.getElementById("add_email").value = "";

        const modalEl = document.getElementById("addCustomerModal");
        const addModalInstance = bootstrap.Modal.getOrCreateInstance(modalEl);
        addModalInstance.show();
    }

    function openEditCustomerModal(id, firstName, lastName, address, telephone, email) {
        document.getElementById("editCustomerModalLabel").innerText = "Edit Customer";
        document.getElementById("edit_customer_id").value = id;
        document.getElementById("edit_first_name").value = firstName;
        document.getElementById("edit_last_name").value = lastName;
        document.getElementById("edit_address").value = address;
        document.getElementById("edit_telephone").value = telephone;
        document.getElementById("edit_email").value = email;

        const modalEl = document.getElementById("editCustomerModal");
        const editModalInstance = bootstrap.Modal.getOrCreateInstance(modalEl);
        editModalInstance.show();
    }
</script>

</body>
</html>
