import React, { useState } from "react";
import Header from "./components/Header";
import Footer from "./components/Footer";
import DescriptionIcon from "@mui/icons-material/Description";
import {
    Container,
    TextField,
    Button,
    Typography,
    Grid,
    Paper,
    FormControl,
    InputLabel,
    MenuItem,
    Select
} from "@mui/material";
import api from "./api";

const App = () => {
    const [alertThreshold, setAlertThreshold] = useState("10");
    const [nRecords, setNRecords] = useState("20");
    const [incidents, setIncidents] = useState([]);
    const [selectedIncident, setSelectedIncident] = useState("");
    const [incidentDetails, setIncidentDetails] = useState("");
    const [strategy, setStrategy] = useState("");
    const [summary, setSummary] = useState(null);
    const [loading, setLoading] = useState(false);
    const [searchIncidentId, setSearchIncidentId] = useState("");

    const fetchIncidents = async () => {
        setLoading(true);
        try {
            const response = await api.get("/ais/v1/incidents", {
                params: { alert_threshold: alertThreshold, n_records: nRecords },
            });
            setIncidents(Array.isArray(response.data) ? response.data : []);
        } catch (error) {
            console.error("Error fetching incidents:", error);
            setIncidents([]);
        } finally {
            setLoading(false);
        }
    };

    const handleIncidentSelect = async (incidentId) => {
        setSelectedIncident(incidentId);
        try {
            const response = await api.get(`/ais/v2/incidents/${incidentId}/alerts`);
            setIncidentDetails(JSON.stringify(response.data, null, 2));
            if (response.data.length > 0) {
                setStrategy("pytextrank");
            }
        } catch (error) {
            console.error("Error fetching incident details:", error);
            setIncidentDetails("");
        }
    };

    const summarizeIncident = async () => {
        const incidentId = searchIncidentId || selectedIncident;
        if (!incidentId || !incidentDetails || !strategy) return;

        try {
            const response = await api.post(
                `/ais/v2/summarize?strategy=${strategy}&incident_id=${incidentId}`
            );
            setSummary(response.data.text);
        } catch (error) {
            console.error("Error summarizing incident:", error);
            setSummary(null);
        }
    };

    const handleSearchIncident = async () => {
        if (!searchIncidentId) return;

        try {
            const response = await api.get(`/ais/v2/incidents/${searchIncidentId}/alerts`);
            setIncidentDetails(JSON.stringify(response.data, null, 2));
            if (response.data.length > 0) {
                setStrategy("pytextrank");
            }
        } catch (error) {
            console.error("Error fetching incident details:", error);
            setIncidentDetails("");
        }
    };

    return (
        <>
            <Header />
            <Container maxWidth={false} className="container">
                <Typography variant="h4" className="heading">
                    Advanced Incident Summarization
                </Typography>
                <Grid container spacing={3} className="main-box">
                    <Grid item xs={12} md={6}>
                        <Paper elevation={4} className="panel">
                            <Grid container spacing={2} className="box-container full-width">
                                <Grid item xs={12}>
                                    <Paper elevation={3} className="panel-container incident-container">
                                        <Typography variant="h6" color="primary" gutterBottom>
                                            Incidents Search
                                        </Typography>
                                        <TextField
                                            label="Alert Threshold"
                                            variant="outlined"
                                            value={alertThreshold}
                                            onChange={(e) => setAlertThreshold(e.target.value)}
                                            className="textfield"
                                        />
                                        <TextField
                                            label="No. of Records"
                                            variant="outlined"
                                            value={nRecords}
                                            onChange={(e) => setNRecords(e.target.value)}
                                            className="textfield"
                                        />
                                        <Button
                                            variant="contained"
                                            onClick={fetchIncidents}
                                            className="button button-custom"
                                            disabled={loading}
                                        >
                                            {loading ? "Fetching..." : "Get Incidents"}
                                        </Button>
                                    </Paper>
                                </Grid>
                                <Grid item xs={12}>
                                    {incidents.length > 0 && (
                                        <Paper elevation={3} className="panel-container">
                                            <FormControl fullWidth className="incident-form">
                                                <InputLabel>Incidents</InputLabel>
                                                <Select
                                                    value={selectedIncident}
                                                    onChange={(e) => handleIncidentSelect(e.target.value)}
                                                    disabled={loading || incidents.length === 0}
                                                >
                                                    {incidents.map((incident) => (
                                                        <MenuItem key={incident.id} value={incident.id}>
                                                            Incident {incident.id} - {incident.n_alerts} alerts
                                                        </MenuItem>
                                                    ))}
                                                </Select>
                                            </FormControl>
                                        </Paper>
                                    )}
                                </Grid>
                                <Grid item xs={12}>
                                    <Paper elevation={3} className="panel-container">
                                        <TextField
                                            label="Search Incident by ID"
                                            variant="outlined"
                                            value={searchIncidentId}
                                            onChange={(e) => setSearchIncidentId(e.target.value)}
                                            className="textfield full-width"
                                        />
                                        <Button
                                            variant="contained"
                                            onClick={handleSearchIncident}
                                            className="button button-custom"
                                        >
                                            Search
                                        </Button>
                                    </Paper>
                                </Grid>
                            </Grid>
                        </Paper>
                    </Grid>
                    <Grid item xs={12} md={6}>
                        <Paper elevation={4} className="panel">
                            <Grid container spacing={2} className="box-container full-width">
                                <Grid item xs={12}>
                                    <Paper elevation={3} className="panel-container">
                                        <Button
                                            variant="contained"
                                            className="button button-custom summarize-button"
                                            onClick={summarize