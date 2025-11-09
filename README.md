# Andrei Bogdan - x86 Assembly Project

## Overview
This project, developed as part of the *"Arhitectura Sistemelor de Calcul"* course, focuses on implementing memory management routines in x86 assembly language. The primary goal is to **simulate a storage device’s operations**, managing memory blocks efficiently through various subprograms.

---

## Project Structure
- `132_Bogdan_Andrei_0.s` – Implementation of the **unidimensional memory management system**.  
- `132_Bogdan_Andrei_1.s` – Implementation of the **bidimensional memory management system**.  

---

## Project Scope & Requirements
The system simulates storage memory using a **1D or 2D array of blocks**.  

**Constraints and implementation rules:**  
- Each file is allocated **contiguous memory blocks**.  
- If contiguous space is unavailable, allocation fails unless **defragmentation** is performed (only for the 1D version).  
- A **bitmap-like structure** is used to track free and occupied memory blocks efficiently.  

---

## Implementation Details (1D Memory)
For the unidimensional memory system:  
- The storage device has a fixed capacity of **8MB**.  
- Memory is divided into **8kB blocks**.  

**Functionalities:**  
1. **Add (File Allocation):** Finds contiguous free blocks to store files. Allocates blocks and updates memory if space is available; otherwise, allocation fails.  
2. **Get (File Retrieval):** Retrieves the starting and ending memory blocks of a file based on its ID and displays its content.  
3. **Delete (File Deallocation):** Frees memory blocks associated with a file ID for future allocations.  
4. **Defragmentation (Memory Optimization):** Shifts all allocated blocks to the beginning of memory, eliminating gaps between blocks. *(Implemented only for the 1D version.)*

---

## How to Run the Project
To execute the program, use a Linux terminal. Follow these steps:

1. Open the terminal and navigate to the project folder.  
2. Assemble, link, and run the **1D memory program**:
   ```bash
   gcc -m32 132_Bogdan_Andrei_0.s -o project0 -no-pie -g
   ./project0
