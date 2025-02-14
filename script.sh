<FormControl fullWidth sx={{ mt: 2 }}>
  <InputLabel>Incidents</InputLabel>
  <Select
    value={selectedIncident || ""}
    onChange={handleIncidentSelect} // Fix applied
    disabled={loading || incidents.length === 0} // Disable when fetching
    sx={{ backgroundColor: "white", borderRadius: 1 }}
  >
    {incidents.map((incident) => (
      <MenuItem key={incident.incident_id} value={incident.incident_id}>
        {`Incident ${incident.incident_id} - ${incident.n_alerts} alerts`}
      </MenuItem>
    ))}
  </Select>
</FormControl>