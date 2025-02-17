import { PieChart, Pie, Cell, Tooltip, Legend } from "recharts";

const COLORS = ["#0088FE", "#FFBB28"]; // Blue for original, Yellow for summarized

const SummaryChart = ({ stats }) => {
  if (!stats) return null; // Don't render if no data

  const data = [
    { name: "Original Words", value: stats.text.words },
    { name: "Summary Words", value: stats.summary.words },
  ];

  return (
    <PieChart width={300} height={300}>
      <Pie
        data={data}
        cx="50%"
        cy="50%"
        innerRadius={60}
        outerRadius={80}
        fill="#8884d8"
        dataKey="value"
        label
      >
        {data.map((entry, index) => (
          <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
        ))}
      </Pie>
      <Tooltip />
      <Legend />
    </PieChart>
  );
};