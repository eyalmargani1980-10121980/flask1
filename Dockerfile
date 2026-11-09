FROM python:3.9-slim
WORKDIR /app
RUN pip install flask 
copy app.py .
EXPOSE 5000 
CMD ["python","app.py"]
