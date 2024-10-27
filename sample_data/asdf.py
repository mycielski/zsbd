import random

from sqlalchemy import (Column, DateTime, Float, ForeignKey, Integer, String,
                        create_engine, text, func)
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

# Database configuration
DATABASE_URL = "postgresql://postgres:xOMMJ0NpO3@raspberrypi:30956/eltrans"

# Create an engine and a session
engine = create_engine(DATABASE_URL)
Session = sessionmaker(bind=engine)
session = Session()

Base = declarative_base()


# Define the Measurement and Sale models
class Measurement(Base):
    __tablename__ = 'measurement'
    id = Column(Integer, primary_key=True)
    fuel_level = Column(Float, nullable=False)
    timestamp = Column(DateTime, nullable=False)
    vehicle_id = Column(Integer, ForeignKey('vehicle.id'), nullable=False)


class Vehicle(Base):
    __tablename__ = 'vehicle'
    id = Column(Integer, primary_key=True)
    number_plate = Column(String, unique=True, nullable=False)
    fuel_capacity = Column(Float)


# select random vehicle
vehicle = session.query(Vehicle).order_by(func.random()).first()

# create one random measurement for the vehicle
measurement = Measurement(fuel_level=random.uniform(0, vehicle.fuel_capacity),
                          timestamp=func.now(),
                          vehicle_id=vehicle.id)

session.add(measurement)

# commit the transaction
session.commit()