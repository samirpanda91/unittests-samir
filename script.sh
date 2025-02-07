import React, { useState, useEffect } from "react";
import { Container, TextField, Select, MenuItem, FormControl, InputLabel, Button, Typography } from "@mui/material";
import axios from "axios";

const App = () => {
  const [text1, setText1] = useState("");
  const [text2, setText2] = useState("");
  const [dropdown, setDropdown] = useState("");
  const [options, setOptions] = useState([]);

  useEffect(() => {
    // Fetch dropdown options from API
    axios.get("https://jsonplaceholder.typicode.com/users")
      .then((response) => {
        setOptions(response.data.map(user => ({ id: user.id, name: user.name })));
      })
      .catch((error) => console.error("Error fetching data:", error));
  }, []);

  const handleSubmit = () => {
    console.log({ text1, text2, dropdown });
    alert(`Submitted: ${text1}, ${text2}, ${dropdown}`);
  };

  return (
    <Container maxWidth="sm" sx={{ mt: 5, p: 3, boxShadow: 3, borderRadius: 2 }}>
      <Typography variant="h5" gutterBottom>React Form</Typography>

      <TextField 
        fullWidth 
        label="First Text Field" 
        variant="outlined" 
        value={text1} 
        onChange={(e) => setText1(e.target.value)} 
        margin="normal"
      />

      <TextField 
        fullWidth 
        label="Second Text Field" 
        variant="outlined" 
        value={text2} 
        onChange={(e) => setText2(e.target.value)} 
        margin="normal"
      />

      <FormControl fullWidth margin="normal">
        <InputLabel>Select an Option</InputLabel>
        <Select value={dropdown} onChange={(e) => setDropdown(e.target.value)}>
          {options.map((option) => (
            <MenuItem key={option.id} value={option.name}>
              {option.name}
            </MenuItem>
          ))}
        </Select>
      </FormControl>

      <Button variant="contained" color="primary" fullWidth onClick={handleSubmit} sx={{ mt: 2 }}>
        Submit
      </Button>
    </Container>
  );
};

export default App;