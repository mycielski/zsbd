import random
from datetime import timedelta

import matplotlib.pyplot as plt
from sqlalchemy import (Column, DateTime, Float, ForeignKey, Integer, String,
                        create_engine, text)
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from tqdm import tqdm

# Database configuration
DATABASE_URL = "postgresql://postgres:xOMMJ0NpO3@raspberrypi:30956/eltrans"

# Create an engine and a session
engine = create_engine(DATABASE_URL)
Session = sessionmaker(bind=engine)
session = Session()

Base = declarative_base()

# check connection by printing all table names in db
tables = session.execute(text("SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'")).fetchall()
print(tables)


# Define the Measurement and Sale models
class Measurement(Base):
    __tablename__ = 'measurement'
    id = Column(Integer, primary_key=True)
    fuel_level = Column(Float, nullable=False)
    timestamp = Column(DateTime, nullable=False)
    vehicle_id = Column(Integer, ForeignKey('vehicle.id'), nullable=False)


class Sale(Base):
    __tablename__ = 'sale'
    id = Column(Integer, primary_key=True)
    cost = Column(Float, nullable=False)
    currency_code = Column(String(3), nullable=False)
    location = Column(String, nullable=True)
    card_id = Column(Integer, ForeignKey('card.id'), nullable=False)
    vendor_id = Column(Integer, ForeignKey('vendor.id'), nullable=False)
    fuel_amount = Column(Float)
    fuel_type_id = Column(Integer, ForeignKey('fuel_type.id'))
    timestamp = Column(DateTime, nullable=False)


class Vehicle(Base):
    __tablename__ = 'vehicle'
    id = Column(Integer, primary_key=True)
    number_plate = Column(String, unique=True, nullable=False)
    fuel_capacity = Column(Float)


class Card(Base):
    __tablename__ = 'card'
    id = Column(Integer, primary_key=True)
    owner_id = Column(Integer, ForeignKey('driver.id'), nullable=False)
    vendor_id = Column(Integer, ForeignKey('vendor.id'), nullable=False)
    card_number = Column(String, unique=True, nullable=False)


class FuelType(Base):
    __tablename__ = 'fuel_type'
    id = Column(Integer, primary_key=True)
    name = Column(String, nullable=False)


class Vendor(Base):
    __tablename__ = 'vendor'
    id = Column(Integer, primary_key=True)
    name = Column(String, nullable=False)
    country = Column(String, nullable=False)
    tax_id = Column(String, nullable=False)


# Function to generate measurements and sales
def generate_fake_data():
    trips = session.execute(text("SELECT id, start_time, end_time, vehicle, driver_id FROM trip")).fetchall()

    for index, trip in tqdm(enumerate(trips)):
        measurements = []  # for plotting
        trip_id, start_time, end_time, vehicle_plate, driver_id = trip

        # Fetch vehicle details
        vehicle = session.execute(text("SELECT id, fuel_capacity, fuel_type_id FROM vehicle WHERE number_plate = :plate"),
                                  {'plate': vehicle_plate}).fetchone()

        vehicle_id, fuel_capacity, fuel_type_id = vehicle

        # Generate measurements
        duration = (end_time - start_time).total_seconds()
        num_measurements = int(duration / 3) + 1
        fuel_level = fuel_capacity  # Start at full capacity

        for i in range(num_measurements):
            timestamp = start_time + timedelta(seconds=i * 3)

            # Simulate fuel level decreasing linearly
            fuel_level = fuel_level - fuel_capacity / num_measurements * random.normalvariate(1, 4)
            measurements.append(fuel_level)  # for plotting
            measurement = Measurement(fuel_level=fuel_level, timestamp=timestamp, vehicle_id=vehicle_id)
            session.add(measurement)
            # session.commit()

            # Simulate refueling at random points
            if fuel_level/fuel_capacity > 0.2:
                continue

            if random.random() < 0.001 or fuel_level/fuel_capacity < 0.01:
                refuel_amount = (fuel_capacity - fuel_level) * random.normalvariate(1, 0.1)
                fuel_level = min(fuel_level + refuel_amount, fuel_capacity)

                # Create a sale for the refuel
                # start by selecting random card belonging to the driver
                card = session.execute(text("SELECT id, vendor_id FROM card WHERE owner_id = :driver_id ORDER BY RANDOM() LIMIT 1"),
                                       {'driver_id': driver_id}).fetchone()
                card_id = card[0]
                vendor_id = card[1]

                # get the vendor's country
                vendor_country = session.execute(text("SELECT country FROM vendor WHERE id = :vendor_id"),
                                                 {'vendor_id': vendor_id}).fetchone()[0]


                fuel_type = 1  # Diesel
                refuel_amount = refuel_amount + (50 * random.normalvariate(0.9, 0.1) if index in [5, 15, 30] else 0)  # Add 50 liters to the 6th trip to simulate fraud
                sale = Sale(
                    cost=round(refuel_amount * 1.5 * random.normalvariate(1, 0.1), 2),  # 1.5 EUR per liter
                    currency_code='EUR',
                    card_id=card_id,
                    location=vendor_country,
                    vendor_id=vendor_id,
                    fuel_amount=round(refuel_amount, 2),
                    fuel_type_id=fuel_type,
                    timestamp=timestamp+timedelta(seconds=1)
                )

                session.add(sale)
                session.commit()

        # plot measurements
        plt.plot(measurements, label=vehicle_plate)
        plt.show()


    session.commit()
    print("Fake data generation completed.")


if __name__ == "__main__":
    generate_fake_data()
