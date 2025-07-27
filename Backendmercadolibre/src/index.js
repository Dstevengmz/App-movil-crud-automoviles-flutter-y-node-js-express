import express from "express";
import mongoose from "mongoose";
import dotenv from "dotenv";
import userRouter from "./routers/user.js";
import carroRouter from "./routers/carro.js";
dotenv.config();

const app = express();

const port = process.env.PORT || 4400;
app.use(express.json());
mongoose
  .connect(process.env.MONGODB_URI, {})
  .then(() => {
    console.log("Conectado a la base de datos MongoDB");
  })
  .catch((err) => {
    console.error("Error al conectar a la base de datos MongoDB", err);
  });

app.use("/api", userRouter);
app.use("/api", carroRouter);
app.get("/", (req, res) => {
  res.send("La pagina esta corriendo");
});

app.listen(9000, '0.0.0.0', () => {
  console.log('Servidor corriendo en http://0.0.0.0:9000');
});

