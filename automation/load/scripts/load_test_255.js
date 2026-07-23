import http from 'k6/http';
import { check } from 'k6';

export default function () {
    let res = http.get('https://api.example.com/health');
    check(res, { 'status is 200': (r) => r.status === 200 });
    // TODO: add more realistic load scenario for test 255
}
