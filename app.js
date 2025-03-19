<Paper elevation={4} className="panel">
    <Typography variant="h6" color="primary" gutterBottom>
        Summarization
    </Typography>
    <div className="summary-container">
        {/* Strategy Dropdown */}
        <FormControl className="strategy-select">
            <InputLabel shrink sx={{ backgroundColor: "white", px: 1 }}>
                Strategy
            </InputLabel>
            <Select
                variant="outlined"
                value={strategy}
                onChange={(e) => setStrategy(e.target.value)}
            >
                <MenuItem value="pytextrank">pytextrank</MenuItem>
                <MenuItem value="nltk">nltk</MenuItem>
            </Select>
        </FormControl>
        {/* Summarize Button */}
        <Button
            variant="contained"
            className="summarize-button"
            onClick={summarizeIncident}
            disabled={!selectedIncident || !strategy}
        >
            Summarize
        </Button>
    </div>
</Paper>