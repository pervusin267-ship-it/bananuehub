from http.server import BaseHTTPRequestHandler
import json
import os
import requests

class handler(BaseHTTPRequestHandler):
    def do_POST(self):
        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length)
        data = json.loads(post_data)
        
        api_key = os.environ.get("OPENAI_API_KEY")
        query = data.get("query", "")

        response = requests.post(
            "https://openai.com",
            headers={"Authorization": f"Bearer {api_key}", "Content-Type": "application/json"},
            json={
                "model": "gpt-3.5-turbo",
                "messages": [
                    {"role": "system", "content": "You are a Roblox Luau Expert. No comments. Only code."},
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
      
