const express = require("express");
const axios = require("axios");
const app = express();

app.use(express.json());

app.get("/convert", async (req, res) => {
  const { from, to, amount } = req.query;

  try {
    const response = await axios.get(
      `https://api.exchangerate-api.com/v4/latest/${from}`
    );

    const rate = response.data.rates[to];
    const result = amount * rate;

    res.json({ result });
  } catch (err) {
    res.status(500).json({ error: "Erreur conversion" });
  }
});

app.listen(3000, () => console.log("Server running on port 3000"));
