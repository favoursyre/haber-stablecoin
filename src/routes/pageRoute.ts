//This handles the various pages for Haber website

//Libraries -->
import express, { IRouter } from "express";
import {
  homePage,
  loginPage,
} from "../controllers/pageController";

//Commencing the app
const router: IRouter = express.Router();

//Homepage
router.get("/", homePage);

//About route

//Contact-Us route

//Login route
router.get("/login", loginPage);

//Signup route
//router.post("/signup", signupPage);

//Documentation route

//Terms of services route

//Privacy Policy route

//Customer protection route

export default router;
