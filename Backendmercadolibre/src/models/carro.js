import mongoose from "mongoose";

const userSchema = new mongoose.Schema({
  marca: {
    type: String,
    required: true,
  },
  modelo: {
    type: String,
    required: true,
  },
  anio: {
    type: Number,
    required: true,

  },
  disponible: {
    type: Boolean,
    required: true,
  },
    imagenUrl: {
    type: String,
    required: true,
  },
});

const Carro = mongoose.model("Carro", userSchema);
export default Carro;
