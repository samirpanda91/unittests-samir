import React, { useState } from "react";
import Header from "./components/Header";
import Footer from "./components/Footer";
import DescriptionIcon from "@mui/icons-material/Description";
import {
    Container,
    TextField,
    Button,
    Typography,
    Grid2,
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
    const [summaryStats, setSummaryStats] = useState(null);

    // Fetch incidents from API
    const fetchIncidents = async () => {
        setLoading(true);
        try {
            const response = await api.get("/als/v1/incidents", {
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

    // Fetch incident details when an incident is selected
    const handleIncidentSelect = async (incidentId) => {
        setSelectedIncident(incidentId);
        try {
            const response = await api.get(`/ais/v2/incidents/${incidentId}/alerts`);
            const descriptions = response.data
                .map((item) => `${item.identifier}: ${item.description}`)
                .join(" ");
            setIncidentDetails(JSON.stringify(response.data, null, 2)); // Format JSON response
            if (response.data.length > 0) {
                setStrategy("pytextrank");
            }
        } catch (error) {
            console.error("Error fetching incident details:", error);
            setIncidentDetails("");
        }
    };

    // Summarize the selected incident
    const summarizeIncident = async () => {
        if (!selectedIncident || !incidentDetails || !strategy) return;

        try {
            const response = await api.post(
                `/ais/v2/summarize?strategy=${strategy}`,
                { content: incidentDetails }
            );
            setSummary(response.data.text);
            if (response.data.stats) {
                setSummaryStats(response.data.stats);
            }
        } catch (error) {
            console.error("Error summarizing incident:", error);
            setSummary(null);
        }
    };

    return (
        <Container maxWidth={false} className="container">
            <Typography variant="h4" className="heading">
                Advanced Incident Summarization
            </Typography>
            <Grid2 className="main-box">
                <Paper elevation={4} className="panel">
                    <Grid2 className="box-container">
                        {/* Box 1: Alert Threshold + No.of Records + Get Incidents */}
                        <Grid2 className="box-container-inner">
                            <Paper elevation={3} className="panel-container">
                                <Typography variant="h6" color="primary" gutterBottom>
                                    Incidents Search
                                </Typography>
                                <TextField
                                    label="Minimum Alerts"
                                    variant="outlined"
                                    value={alertThreshold}
                                    onChange={(e) => setAlertThreshold(e.target.value)}
                                    className="textfield full-width .MulInputBase-root"
                                />
                                <TextField
                                    label="No. of Records"
                                    variant="outlined"
                                    fullWidth
                                    value={nRecords}
                                    onChange={(e) => setNRecords(e.target.value)}
                                    className="textfield full-width .MulInputBase-root"
                                />
                                <Button
                                    variant="contained"
                                    onClick={fetchIncidents}
                                    className="button button-custom full-width"
                                    disabled={loading}
                                >
                                    {loading ? "Fetching..." : "Get Incidents"}
                                </Button>
                            </Paper>
                        </Grid2>

                        {/* Box 2: Dropdown for Incidents */}
                        <Grid2 className="box-container-inner">
                            <Paper elevation={3} className="panel-container">
                                {incidents.length > 0 && (
                                    <FormControl fullWidth className="incident-form mt-1">
                                        <InputLabel shrink className="incident-label" sx={{ backgroundColor: "white", px: 1 }}>
                                            Incidents
                                        </InputLabel>
                                        <Select
                                            value={selectedIncident || ""}
                                            onChange={(e) => handleIncidentSelect(e.target.value)}
                                            disabled={loading || incidents.length === 0}
                                            className="incident-select"
                                            MenuProps={{ PaperProps: { className: "incident-menu" } }}
                                        >
                                            {incidents.map((incident) => (
                                                <MenuItem key={incident.id} value={incident.id}>
                                                    {`Incident ${incident.id} - ${incident.n_alerts} alerts`}
                                                </MenuItem>
                                            ))}
                                        </Select>
                                    </FormControl>
                                )}
                                {selectedIncident && (
                                    <TextField
                                        label="Text to Summarize"
                                        multiline
                                        variant="outlined"
                                        value={incidentDetails}
                                        onChange={(e) => setIncidentDetails(e.target.value)}
                                        className="multiline-textbox mt-2 full-width"
                                    />
                                )}
                            </Paper>
                        </Grid2>
                    </Grid2>
                </Paper>

                {/* Right Panel: Summary */}
                <Paper elevation={4} className="panel">
                    <Grid2 className="box-container-summary">
                        <Typography variant="h6" color="primary" gutterBottom>
                            Summarization
                        </Typography>
                        <FormControl className="full-width mb-2">
                            <InputLabel shrink sx={{ backgroundColor: "white", px: 1 }}>
                                Strategy
                            </InputLabel>
                            <Select
                                variant="outlined"
                                value={strategy}
                                onChange={(e) => setStrategy(e.target.value)}
                                className="textfield"
                            >
                                <MenuItem value="pytextrank">pytextrank</MenuItem>
                                <MenuItem value="nltk">nltk</MenuItem>
                            </Select>
                        </FormControl>
                        <Button
                            variant="contained"
                            className="button button-custom full-width summarize-button"
                            onClick={summarizeIncident}
                            disabled={!selectedIncident || !strategy}
                        >
                            Summarize
                        </Button>
                        {summaryStats && (
                            <Grid2 className="box-right box-right-inside">
                                <Grid2 className="box-right-inside">
                                    <DescriptionIcon fontSize="extra small" color="primary" />
                                    <Typography>Words: {summaryStats.text.sentences} + {summaryStats.summary.words}</Typography>
                                </Grid2>
                                <Grid2 className="box-right-inside">
                                    <DescriptionIcon fontSize="extra small" color="secondary" />
                                    <Typography>Sentences: {summaryStats.text.sentences} + {summaryStats.summary.sentences}</Typography>
                                </Grid2>
                                <Grid2 className="box-right-inside">
                                    <DescriptionIcon fontSize="extra small" color="primary" />
                                    <Typography>Limit Phrases: {summaryStats.params.limit_phrases}</Typography>
                                </Grid2>
                                <Grid2 className="box-right-inside">
                                    <DescriptionIcon fontSize="extra small" color="secondary" />
                                    <Typography>Limit Sentences: {summaryStats.params.limit_sentences}</Typography>
                                </Grid2>
                            </Grid2>
                        )}
                        {summary && (
                            <TextField
                                label="Summary"
                                multiline
                                variant="outlined"
                                value={summary || "No data available to summarize"}
                                className="multiline-textbox multiline-textbox-summary mt-3 full-width"
                            />
                        )}
                    </Grid2>
                </Paper>
            </Grid2>
        </Container>
    );
};

export default App;