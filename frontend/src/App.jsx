import { useState } from "react";
import "./App.css";

function App() {
  const [from, setFrom] = useState("USD");
  const [to, setTo] = useState("TND");
  const [amount, setAmount] = useState(1);
  const [result, setResult] = useState(null);

  const convert = async () => {
    const res = await fetch(
      `http://YOUR_PUBLIC_IP:3000/convert?from=${from}&to=${to}&amount=${amount}`
    );
    const data = await res.json();
    setResult(data.result);
  };

  const switchCurrencies = () => {
    setFrom(to);
    setTo(from);
  };

  return (
    <div className="container">
      <h1>Currency Converter</h1>

      <input
        type="number"
        value={amount}
        onChange={(e) => setAmount(e.target.value)}
      />

      <div className="row">
        <input value={from} onChange={(e) => setFrom(e.target.value)} />
        <button onClick={switchCurrencies}>🔄</button>
        <input value={to} onChange={(e) => setTo(e.target.value)} />
      </div>

      <button onClick={convert}>Convert</button>

      {result && <h2>{result}</h2>}
    </div>
  );
}

export default App;
