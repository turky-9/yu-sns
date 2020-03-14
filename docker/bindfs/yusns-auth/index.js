"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
var express_1 = __importDefault(require("express"));
// import jwt, { VerifyErrors } from 'jsonwebtoken';
var app = express_1.default();
// CORSの許可
app.use(function (req, res, next) {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Header', 'Origin, X-Requested-With, Content-Type, Accept');
    next();
});
var secret = 'hogehogehoge';
var users = [
    { id: 'haru', pass: 'haru2000' }
];
// request bodyの解析
app.use(express_1.default.json());
app.use(express_1.default.urlencoded({ extended: true }));
// get and post routing
var router = express_1.default.Router();
router.get('/api/getTest', function (req, res) {
    res.send(req.query);
});
router.post('/api/postTest', function (req, res) {
    console.log('post body: ' + req.body.id + ", " + req.body.pass);
    res.send(req.body);
});
// router.post('/api/auth', (req, res) => {
//   const id: string = req.body.id;
//   const pass: string = req.body.pass;
//   console.log('auth body: ' + req.body.id + ", " + req.body.pass);
// 
//   for(const user of users) {
//     if (user.id === id && user.pass === pass) {
//       var token = jwt.sign(id, secret);
//       res.json({
//         success: true,
//         msg: "Authentication successfully finished",
//         token: token
//       });
//       return;
//     }
//   }
// 
//   // IDとパスワードが正しくなかった場合
//   res.json({
//     success: false,
//     msg: "Authentication failed"
//   });
// })
// 一度クライアントに返したtokenが改ざんされずにクライアントから送られてきたか確認
// router.use((req, res, next) => {
//   var token = req.body.token;
//   // tokenがない場合、アクセスを拒否
//   if (!token) {
//     return res.status(403).send({
//       success: false,
//       msg: "No token provided"
//     });
//   }
// 
//   // tokenが改ざんされていないかチェック
//   jwt.verify(token, secret, (err: VerifyErrors, decoded: object) => {
//     // tokenが不正なものだった場合、アクセス拒否
//     if (err) {
//       console.log(err);
//       return res.json({
//         success: false,
//         msg: "Invalid token"
//       });
//     }
//     // 正しいtokenの場合、認証OKする
//     console.log(decoded);
//     next();
//   });
// });
// 
// // 認証後、これ以降のURIにアクセス可能となる
// router.get("/api/private", (req, res) => {
//   res.json({
//     msg: "Hello world!"
//   });
// });
app.use(router);
// listen
app.listen(55555, function () {
    console.log('Express app listening on prot 55555');
});
