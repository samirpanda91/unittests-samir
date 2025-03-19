<Grid2 className="box-container full-width">
    {/* Box 1: Alert Threshold + No.of Records + Get Incidents */}
    <Grid2 className="box-container-inner">
        <Paper elevation={3} className="panel-container incident-container">
            <Typography variant="h6" color="primary" gutterBottom>
                Incidents Search
            </Typography>
            <div className="first-line-container">
                <TextField
                    label="Alert Threshold"
                    variant="outlined"
                    value={alertThreshold}
                    onChange={(e) => setAlertThreshold(e.target.value)}
                    className="textField NullInputBase-root"
                />
                <TextField
                    label="No. of Records"
                    variant="outlined"
                    value={nRecords}
                    onChange={(e) => setWRecords(e.target.value)}
                    className="textField NullInputBase-root"
                />
                <Button
                    variant="contained"
                    onClick={fetchIncidents}
                    className="button button-custom"
                    disabled={loading}
                >
                    {loading ? "Fetching..." : "Get Incidents"}
                </Button>
            </div>
            <FormControl fullWidth className="incident-form mt-1">
                <InputLabel shrink className="incident-label" sx={{ backgroundColor: "#f0f0f0", px: 1 }}>
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
                            Incident {incident.id} - {incident.n_alerts} alerts
                        </MenuItem>
                    ))}
                </Select>
            </FormControl>
        </Paper>
    </Grid2>
</Grid2>