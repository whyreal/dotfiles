import axios from "axios";

export const fromES = axios.create({
    //baseURL: 'http://elastic:ujwELANchGKFyt5AVLJa@192.168.0.23:9201/',
    timeout: 10000,
    headers: {'Content-Type': 'application/json'}
});

export const toES = axios.create({
    //baseURL: 'http://elastic:XqTa0yMJ03cPLogEHOTw@192.168.0.223:9201/',
    timeout: 100000,
    headers: {'Content-Type': 'application/json'}
});

