package main

import (
	"io"
	"log"
	"net/http"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/logger"
)

func main() {
	app := fiber.New()

	app.Use(logger.New())

	app.Get("/", func(c *fiber.Ctx) error {
		return c.SendString("Hello, World!")
	})

	app.Get("/health", func(c *fiber.Ctx) error {
		return c.SendStatus(200)
	})

	app.Get("/bye", func(c *fiber.Ctx) error {
		return c.SendString("Bye, World!")
	})

	app.Get("/weather", func(c *fiber.Ctx) error {
		url := "https://wttr.in"

		res, err := http.Get(url)
		if err != nil {
			return c.Status(500).SendString(err.Error())
		}

		data, err := io.ReadAll(res.Body)
		if err != nil {
			return c.Status(500).SendString(err.Error())
		}

		c.Set("content-type", "text/html")
		return c.Send(data)
	})

	log.Fatal(app.Listen(":3000"))
}
