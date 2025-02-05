Filtering
	•	By default, incidentStartTime is set to midnight (00:00:00 EST) of the current day. Users can modify this by specifying it in the filters using the format %Y-%m-%d 00:00:00.
	•	Filters can be included in the query, as shown in the example. Multiple filters can be provided, separated by commas.
	•	For datetime filters, if searching between two dates, the start and end dates should be specified as an array. The first element represents the start date, and the second represents the end date.
Example: incidentStartTime: ["2024-11-10 00:00:00", "2024-11-14 00:00:00"]