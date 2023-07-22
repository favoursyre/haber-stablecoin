//This handles the various functions for the page links

//Libraries -->
import jwt from "jsonwebtoken";
import express, {Application, Request, Response, NextFunction} from "express"
//const User = require("../models/userModel");
//require("dotenv").config();

//Commencing the app
const SECRET: string = process.env.SECRET!;

//Declaring the various interfaces
interface View {
    msg: string
}

//This handles the function of JWT
const createToken = (_id: string) => {
  return jwt.sign({ _id }, SECRET, { expiresIn: "3d" });
};

// Homepage
export const homePage = (req: Request, res: Response) => {
  try {
    const view: View = { msg: "Homepage" };
    res.status(200).json(view);
  } catch (error) {
    const error_: View = {msg: `${error}`}
    res.status(400).json(error_);
  }
};

//Login Page
export const loginPage = async (req: Request, res: Response) => {
//   const { email, password } = req.body;
//   try {
//     const user = await User.login(email, password);
//     const token = createToken(user._id);
//     res.status(200).json({ token });
//   } catch (error) {
//     res.status(400).json({ error: error.message });
//   }

try {
    const view: View = { msg: "Login page" };
    res.status(200).json(view);
  } catch (error) {
    const error_: View = {msg: `${error}`}
    res.status(400).json(error_);
  }
};

//Signup page
// export const signupPage = async (req: Request, res: Response) => {
//   const {
//     firstName,
//     lastName,
//     displayName,
//     email,
//     dateOfBirth,
//     phoneNumber,
//     password,
//     passwordCopy,
//     country,
//     state,
//     referralID,
//   } = req.body;
//   try {
//     const user = await User.signup(
//       firstName,
//       lastName,
//       displayName,
//       email,
//       dateOfBirth,
//       phoneNumber,
//       password,
//       passwordCopy,
//       country,
//       state,
//       referralID
//     );
//     const token = createToken(user._id);
//     res.status(200).json({ token });
//   } catch (error) {
//     res.status(400).json({ error: error.message });
//   }
// };


