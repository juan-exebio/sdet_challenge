# API Bug Report

## Overview
This report details the behavior discrepancies and critical bugs found across the **DEV** and **PROD** environments. 
* ⚠️ **Critical Severity:** Multiple actions result in unexpected `201 Created` or `500 Internal Server Error` statuses.
* 📝 **Note on Expected Results:** The documentation indicates that validation failures consistently expect a `"User not found"` message; however, actual error payloads vary significantly.

---

## 1. POST `/users` (Create User)

| Test Case / Payload Condition | Expected Result | Actual Result (DEV) | Actual Result (PROD) | Status |
| :--- | :--- | :--- | :--- | :---: |
| **1.** Empty JSON body | `400` / "User not found" | `400` / "name is required" | `400` / "name is required" | ⚠️ Mismatch |
| **2.** Empty `name` string | `400` / "User not found" | `400` / "name is required" | `400` / "name is required" | ⚠️ Mismatch |
| **3.** Empty `name`, `email`, and `age` | `400` / "User not found" | `400` / "name is required" | `400` / "name is required" | ⚠️ Mismatch |
| **4.** Invalid `email` format | `400` / "User not found" | `201` / User created | `201` / User created | ❌ Critical Bug |
| **5.** `age` provided as a string | `400` / "User not found" | `400` / "Age must be between 1 and 150" | `400` / "Age must be between 1 and 150" | ⚠️ Mismatch |
| **6.** `name` & `email` as integers | `400` / "User not found" | `201` / User created | `201` / User created | ❌ Critical Bug |
| **7.** Duplicate `email` registration | `409` / "User not found" | `500` / "Internal server error" | `500` / "Internal server error" | ❌ Critical Bug |

---

## 2. PUT `/users` (Update User)

| Test Case / Payload Condition | Expected Result | Actual Result (DEV) | Actual Result (PROD) | Status |
| :--- | :--- | :--- | :--- | :---: |
| **1.** Standard user update | `200` / User updated | `200` / Changes lost on next query | `200` / Next query throws `500` | ❌ Critical Bug |
| **2.** Invalid `age` property | `400` / "User not found" | `400` / "Age must be between 1 and 150" | `400` / "Age must be between 1 and 150" | ⚠️ Mismatch |
| **3.** Invalid `name` & `email` | `400` / "User not found" | `500` / "Internal server error" | `500` / "Internal server error" | ❌ Critical Bug |
| **4.** Update to duplicate `email` | `409` / "User not found" | `200` / User info updated | `200` / User info updated | ❌ Critical Bug |

---

## 3. GET `/users` (Fetch User)

| Test Case / Payload Condition | Expected Result | Actual Result (DEV) | Actual Result (PROD) | Status |
| :--- | :--- | :--- | :--- | :---: |
| **1.** Non-existent user by Email | `404` / "User not found" | `500` / "Internal Server" | `500` / "Internal Server" | ❌ Critical Bug |
| **2.** Non-existent / unencoded email | `404` / "User not found" | `500` / "Internal Server" | `500` / "Internal Server" | ❌ Critical Bug |
| **3.** Valid user / unencoded email | `404` / "User not found" | `200` / User info returned | `200` / User info returned | ⚠️ Mismatch |

---

## 4. DELETE `/users` (Remove User)

*Note: Delete data is currently only recorded for the DEV environment.*

| Test Case / Payload Condition | Expected Result | Actual Result (DEV) | Actual Result (PROD) | Status |
| :--- | :--- | :--- | :--- | :---: |
| **1.** Invalid authorization token | `401` / "User not found" | `204` / No Content | Passed | ❌ Critical Bug |
| **2.** Missing authorization header | `401` / "User not found" | `204` / No Content | Passed | ❌ Critical Bug |
