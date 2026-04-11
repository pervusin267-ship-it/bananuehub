from http.server import BaseHTTPRequestHandler
import json
import requests

class handler(BaseHTTPRequestHandler):
    def do_POST(self):
        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length)
        data = json.loads(post_data)
        
        query = data.get("query", "")

        response = requests.post(
            "https://v8.tf",
            headers={"Content-Type": "application/json"},
            json={
                "model": "gpt-3.5-turbo",
                "messages": [
                    {"role": "system", "content": "You are a Roblox Scripting God. No talk, only Luau code. No comments."},
                    {"role": "user", "content": query}
                ]
            }
        )
        
        result = response.json()
        answer = result['choices'][0]['message']['content']

        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.end_headers()
        self.wfile.write(json.dumps({"answer": answer}).encode())
        
