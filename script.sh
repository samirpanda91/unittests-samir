/* Base Styles */
.multiline-textbox {
  background-color: white !important;
  border-radius: 8px !important;
}

/* Responsive Adjustments */
@media (max-width: 768px) {  /* Tablets & Mobile */
  .multiline-textbox {
    border-radius: 4px !important;
  }
  .multiline-textbox .MuiInputBase-input {
    min-height: 250px !important; /* Smaller height for smaller screens */
    max-height: 400px !important;
  }
}

@media (max-width: 480px) {  /* Mobile */
  .multiline-textbox {
    border-radius: 2px !important;
  }
  .multiline-textbox .MuiInputBase-input {
    min-height: 200px !important;
    max-height: 300px !important;
  }
}