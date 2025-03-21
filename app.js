<Grid2 className="box-container-inner">
    <Paper elevation={0} className="panel-container incident-container">
        <Typography variant="h6" color="primary" gutterBottom className="incident-title">
            Incidents Search
        </Typography>
        <div className="input-container">
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
        </div>
    </Paper>
</Grid2>