//This handles the server for Haber Inc.

//Libraries -->
import express, {Application, Request, Response, NextFunction} from "express"
import mongoose from "mongoose"
import * as dotenv from 'dotenv';
import pageRoutes from "./routes/pageRoute"

//Commencing with the app
dotenv.config();
const app: Application = express()
const PORT: number = Number(process.env.PORT);
console.log("mongo: ", process.env.MONGO_URL)
const MONGO_URL: string = process.env.MONGO_URL!;

//The middleware
app.use(express.json());
app.use((req: Request, res: Response, next: NextFunction) => {
  console.log("Middleware: ", req.path, req.method);
  next();
});

//The routes
app.use("/", pageRoutes);

//Connecting the app to MongoDB
mongoose
  .connect(MONGO_URL)
  .then(() => {
    //Listen for requests
    app.listen(PORT, () => {
      console.log("Server connected to DB and listening on port", PORT);
    });
  })
  .catch((error) => {
    console.log("DB Error: ", error);
  });