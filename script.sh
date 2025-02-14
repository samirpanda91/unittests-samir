import React from "react";
import { AppBar, Toolbar, Typography } from "@mui/material";

const Header = () => {
  return (
    <AppBar position="static" sx={{ backgroundColor: "#1976D2" }}>
      <Toolbar>
        <Typography variant="h6" sx={{ flexGrow: 1, textAlign: "center" }}>
          Incident Management Dashboard
        </Typography>
      </Toolbar>
    </AppBar>
  );
};

export default Header;



import React from "react";
import { Box, Typography } from "@mui/material";

const Footer = () => {
  return (
    <Box
      sx={{
        position: "fixed",
        bottom: 0,
        width: "100%",
        backgroundColor: "#1976D2",
        color: "white",
        textAlign: "center",
        py: 1,
      }}
    >
      <Typography variant="body2">© 2025 Incident Management System</Typography>
    </Box>
  );
};

export default Footer;


import Header from "./components/Header";
import Footer from "./components/Footer";