import React, { useState, useEffect } from "react";
import {
  Container, TextField, Select, MenuItem, FormControl, InputLabel, Button,
  Typography, Card, CardContent
} from "@mui/material";
import axios from "axios";

const App = () => {
  const [text1, setText1] = useState("");
  const [text2, setText2] = useState("");
  const [dropdown, setDropdown] = useState("");
  const [options, setOptions] = useState([]);

  useEffect(() => {
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
    <Container maxWidth="sm" sx={{ mt: 5 }}>
      <Card sx={{ boxShadow: 5, borderRadius: 3, p: 3, backgroundColor: "#f4f6f8" }}>
        <CardContent>
          <Typography variant="h5" textAlign="center" fontWeight="bold" gutterBottom>
            React Form
          </Typography>

          <TextField 
            fullWidth 
            label="First Text Field" 
            variant="outlined" 
            value={text1} 
            onChange={(e) => setText1(e.target.value)} 
            margin="normal"
            sx={{ backgroundColor: "white", borderRadius: 1 }}
          />

          <TextField 
            fullWidth 
            label="Second Text Field" 
            variant="outlined" 
            value={text2} 
            onChange={(e) => setText2(e.target.value)} 
            margin="normal"
            sx={{ backgroundColor: "white", borderRadius: 1 }}
          />

          <FormControl fullWidth margin="normal">
            <InputLabel>Select an Option</InputLabel>
            <Select
              value={dropdown}
              onChange={(e) => setDropdown(e.target.value)}
              sx={{ backgroundColor: "white", borderRadius: 1 }}
            >
              {options.map((option) => (
                <MenuItem key={option.id} value={option.name}>
                  {option.name}
                </MenuItem>
              ))}
            </Select>
          </FormControl>

          <Button
            variant="contained"
            color="primary"
            fullWidth
            onClick={handleSubmit}
            sx={{
              mt: 2,
              py: 1,
              fontSize: "1rem",
              fontWeight: "bold",
              textTransform: "none",
              transition: "0.3s",
              "&:hover": { backgroundColor: "#1976D2" },
            }}
          >
            Submit
          </Button>
        </CardContent>
      </Card>
    </Container>
  );
};

export default App;