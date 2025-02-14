<TextField
  variant="outlined"
  fullWidth
  placeholder="Enter details here..."
  sx={{
    backgroundColor: "white",
    borderRadius: 1,
    border: "1px solid #ADD8E6", // Light blue border
    "& .MuiOutlinedInput-root": {
      "& fieldset": {
        borderColor: "#ADD8E6", // Default border
      },
      "&:hover fieldset": {
        borderColor: "#ADD8E6", // Prevents dark blue on hover
      },
      "&.Mui-focused fieldset": {
        borderColor: "#ADD8E6", // Prevents dark blue when focused
        boxShadow: "0 0 0 2px rgba(173, 216, 230, 0.3)", // Soft blue glow
      },
    },
  }}
/>