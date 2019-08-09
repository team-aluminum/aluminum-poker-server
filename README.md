# Aluminum Poker Server

## 0. 基本情報
* `base_url`: `https://aluminum-poker.herokuapp.com`
* 基本的にユーザー識別のために全アプリ用APIで、parameterに`user_code`を含める

## 1. モバイルユーザー登録API
最初にモバイルアプリにアクセスした時に、サーバー側にアクセスしたことを状態として持つためのAPI
`user_code`はアプリへ飛ばす`alpoker://`で始まるリンクにクエリパラメータとして付いているものを使用
> `POST` `/mobile_events/mobile_user`
### Body parameters
```
{
  "user_code": <String>
}
```

### Success Response
> status: 201
```
{
  "message": "ok"
}
```

## 2. カード読み取りAPI
部屋に入るための鍵の読み取り、トランプを引いた時の読み取り時に叩くAPI
> `POST` `/mobile_events/read_card`
### Body parameters
```
{
  "user_code": <String>,
  "card": <String> // ex) "d4", "h13"
}
```
### Success Response
> status: 200
```
{
  "message": "ok"
}
```
### Error Response
引いたトランプがすでに相手に惹かれていた場合
> status: 400
```
{
  "error_code": "duplicate"
}
```

## 3. モバイル状態取得API
ゲームが始まってからポーリングしてもらうAPI
> `GET` `/mobile_events/status`
### Query parameters
```
/mobile_events/status?user_code=<String>
```

### Response (カード読み取り状態の時)
> status: 200
```
{
  "status": "read_card"
}
```

### Response (自分のアクションの時)
> status: 200
```
{
  "status": "active",
  "limp_label": <String>, // "check" or "call"
  "call_amount": <Integer> or null, // '$30 to call'みたいな文言を表示するための数字
  "min_raise_amount": <Integer>,
  "max_raise_amount": <Integer>
}
```

### Response (相手のアクションの時)
> status: 200
```
{
  "status": "waiting"
}
```

## 4. ポーカーアクションAPI
> `POST` `/mobile_events/action`
### Body parameters
```
{
  "user_code": <String>,
  "type": <String>, // "check", "call", "fold", "raise"
  "amount": <Integer> or null // raiseの時のみ
}
```

### Success Response
```
{
  "message": "ok"
}
```
