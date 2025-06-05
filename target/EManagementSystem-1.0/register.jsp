<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Register - E-Management System</title>
    <link href="Bootstrap/css/bootstrap.min.css" rel="stylesheet" />
    <link href="css/login-style.css" rel="stylesheet" />
</head>
<body>
    <header class="fixed-top d-flex justify-content-between align-items-center px-3">
        <h1 class="h4 m-0">E-Management System</h1>
        <button id="toggleModeBtn" class="btn btn-outline-primary btn-sm">Dark Mode</button>
    </header>

    <main class="container-fluid content-container d-flex justify-content-center align-items-center">
        <div class="card shadow-sm p-4" style="max-width:600px; width: 100%;">
            <h2 class="card-title mb-3 text-center">Register</h2>
            <form action="register" method="post">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">Username</label>
                        <input type="text" name="user_name" class="form-control" required />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Password</label>
                        <input type="password" name="password" class="form-control" required />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">First Name</label>
                        <input type="text" name="first_name" class="form-control" required />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Last Name</label>
                        <input type="text" name="last_name" class="form-control" required />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">NRIC</label>
                        <input type="text" name="nric" class="form-control" required />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Email</label>
                        <input type="email" name="email" class="form-control" required />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Mobile No</label>
                        <input type="text" name="mobile_no" class="form-control" required />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Gender</label>
                        <select name="gender_id" class="form-control" required>
                            <option value="">Select</option>
                            <option value="1">Male</option>
                            <option value="2">Female</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Race</label>
                        <select name="race_id" class="form-control" required>
                            <option value="">Select</option>
                            <option value="1">Malay</option>
                            <option value="2">Chinese</option>
                            <option value="3">Indian</option>
                            <option value="4">Others</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Marital Status</label>
                        <input type="text" name="marital_status" class="form-control" />
                    </div>
                    <div class="col-md-12">
                        <div class="card p-3 mt-2">
                            <h5 class="mb-3">Residential Address</h5>
                            <div class="row g-3">
                                <div class="col-md-12">
                                    <label class="form-label">Address Line 1</label>
                                    <input type="text" name="address1" class="form-control" />
                                </div>
                                <div class="col-md-12">
                                    <label class="form-label">Address Line 2</label>
                                    <input type="text" name="address2" class="form-control" />
                                </div>
                                <div class="col-md-12">
                                    <label class="form-label">Address Line 3</label>
                                    <input type="text" name="address3" class="form-control" />
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Postcode</label>
                                    <input type="text" name="postcode" class="form-control" />
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">City</label>
                                    <select name="city_id" class="form-control">
                                        <option value="">Select</option>
                                        <!-- Add options dynamically if needed -->
                                    </select>
                                </div>
                                <div class="col-md-6 d-none" id="cityOtherContainer">
                                    <label class="form-label">Other City</label>
                                    <input type="text" name="city_other" class="form-control" />
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">District</label>
                                    <select name="district_id" class="form-control">
                                        <option value="">Select</option>
                                        <!-- Add options dynamically if needed -->
                                    </select>
                                </div>
                                <div class="col-md-6 d-none" id="districtOtherContainer">
                                    <label class="form-label">Other District</label>
                                    <input type="text" name="district_other" class="form-control" />
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">State</label>
                                    <select name="state_id" class="form-control">
                                        <option value="">Select</option>
                                        <!-- Add options dynamically if needed -->
                                    </select>
                                </div>
                                <div class="col-md-6 d-none"  id="stateOtherContainer">
                                    <label class="form-label">Other State</label>
                                    <input type="text" name="state_other" class="form-control" />
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Country</label>
                                    <select name="state_id" class="form-control">
                                        <option value="">Select</option>
                                        <!-- Add options dynamically if needed -->
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Company Name</label>
                        <input type="text" name="company_name" class="form-control" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Company No</label>
                        <input type="text" name="company_no" class="form-control" />
                    </div>
                    <div class="col-md-12">
                        <div class="card p-3 mt-2">
                            <h5 class="mb-3">Business Address</h5>
                            <div class="row g-3">
                                <div class="col-md-12">
                                    <label class="form-label">Address Line 1</label>
                                    <input type="text" name="B_address1" class="form-control" />
                                </div>
                                <div class="col-md-12">
                                    <label class="form-label">Address Line 2</label>
                                    <input type="text" name="B_address2" class="form-control" />
                                </div>
                                <div class="col-md-12">
                                    <label class="form-label">Address Line 3</label>
                                    <input type="text" name="B_address3" class="form-control" />
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Postcode</label>
                                    <input type="text" name="B_postcode" class="form-control" />
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">City</label>
                                    <select name="B_city_id" class="form-control">
                                        <option value="">Select</option>
                                        <!-- Add options dynamically if needed -->
                                    </select>
                                </div>
                                <div class="col-md-6 d-none" id="cityOtherContainer">
                                    <label class="form-label">Other City</label>
                                    <input type="text" name="B_city_other" class="form-control" />
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">District</label>
                                    <select name="B_district_id" class="form-control">
                                        <option value="">Select</option>
                                        <!-- Add options dynamically if needed -->
                                    </select>
                                </div>
                                <div class="col-md-6 d-none" id="districtOtherContainer">
                                    <label class="form-label">Other District</label>
                                    <input type="text" name="B_district_other" class="form-control" />
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">State</label>
                                    <select name="B_state_id" class="form-control">
                                        <option value="">Select</option>
                                        <!-- Add options dynamically if needed -->
                                    </select>
                                </div>
                                <div class="col-md-6 d-none"  id="stateOtherContainer">
                                    <label class="form-label">Other State</label>
                                    <input type="text" name="B_state_other" class="form-control" />
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Country</label>
                                    <select name="B_country_id" class="form-control">
                                        <option value="">Select</option>
                                        <!-- Add options dynamically if needed -->
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Hidden audit fields -->
                <input type="hidden" name="aud_add_date" value="<%= new java.util.Date() %>" />
                <input type="hidden" name="aud_add_userid" value="system" />
                <input type="hidden" name="aud_action" value="INSERT" />
                <input type="hidden" name="aud_action_date" value="<%= new java.util.Date() %>" />

                <div class="mt-4">
                    <button type="submit" class="btn btn-success w-100">Register</button>
                </div>
            </form>
            <div class="text-center mt-3">
                <small>Already have an account? <a href="login.jsp">Click here</a></small>
            </div>
        </div>
    </main>

    <footer class="fixed-bottom d-flex justify-content-center align-items-center px-3">
        <small>&copy; 2025 MyApp. All rights reserved.</small>
    </footer>

    <script src="Bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="js/login-script.js"></script> <!-- 👈 Ensure this is correct path -->
</body>
</html>
