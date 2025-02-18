/* Global styles */
.container {
  margin-top: 40px; /* mt: 5 (5 * 8px = 40px) */
  height: 95vh;
  padding: 64px; /* p: 8 (8 * 8px = 64px) */
}

.heading {
  text-align: center;
  font-weight: bold;
  color: #1976d2; /* Primary color in MUI */
  margin-bottom: 16px;
}

.main-box {
  display: flex;
  height: 88vh;
  margin-top: 16px; /* mt: 2 (2 * 8px = 16px) */
  gap: 16px;
}

/* Left and Right Panel */
.panel {
  padding: 24px; /* p: 3 (3 * 8px = 24px) */
  flex: 1;
  display: flex;
  flex-direction: column;
}

/* Small Boxes */
.box-container {
  display: flex;
  gap: 16px;
}

.box {
  flex: 1;
  padding: 16px; /* p: 2 (2 * 8px = 16px) */
}

.box-gray {
  background-color: #f0f0f0;
}

.box-blue {
  background-color: #e3f2fd;
}

/* Dropdown and Inputs */
.full-width {
  width: 100%;
}

.mt-2 {
  margin-top: 16px;
}

.mb-2 {
  margin-bottom: 16px;
}

/* Buttons */
.button {
  font-weight: bold;
}

.button-success {
  background-color: #4caf50;
  color: white;
}

.button-success:hover {
  background-color: #388e3c;
}

/* Incident Details & Summary */
.textarea {
  background-color: white;
  border-radius: 8px;
}